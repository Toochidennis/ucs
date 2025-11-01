import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:get/get.dart';
import 'package:ucs/data/models/clearance_document.dart';
import 'package:ucs/data/models/clearance_requirement.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/services/clearance_details_service.dart';
import 'package:ucs/features/auth/controllers/auth_controller.dart';

class ClearanceDetailsController extends GetxController {
  final _service = ClearanceDetailsService();

  // Inputs
  final unitId = RxnString();

  // State
  final unit = Rxn<ClearanceUnit>();
  final requirements = <ClearanceRequirement>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Existing documents keyed by requirementId (most-recent first)
  final docsByRequirement = <String, List<ClearanceDocument>>{}.obs;

  // Local selections before submit keyed by requirementId (support multiple)
  final selectedFiles = <String, List<PlatformFile>>{}.obs;

  // Derived unit status
  // null means "not submitted yet" so view won't show a status banner
  final unitStatus = Rxn<ClearanceStatusEnum>();
  final errorMessage = RxnString();

  String get unitName => unit.value?.unitName ?? '';

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    final id = (arg is Map && arg['unitId'] is String)
        ? arg['unitId'] as String
        : null;
    if (id != null) {
      unitId.value = id;
      load();
    }
  }

  Future<void> load() async {
    final id = unitId.value;
    if (id == null) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final u = await _service.getUnitWithRequirements(id);
      unit.value = u;
      requirements.assignAll(
        u.requirements..sort((a, b) => a.position.compareTo(b.position)),
      );

      // Load existing docs for this student
      final studentId = Get.find<AuthController>().currentUser.value?.id;
      if (studentId == null) {
        throw Exception('Not authenticated');
      }
      final docs = await _service.getUnitDocuments(studentId, id);
      // For each requirement, capture all docs (ordered by submitted_at desc)
      final map = <String, List<ClearanceDocument>>{};
      for (final r in requirements) {
        final rDocs = docs.where((d) => d.requirementId == r.id).toList();
        map[r.id] = rDocs;
      }
      docsByRequirement.assignAll(map);
      _computeUnitStatus();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _computeUnitStatus() {
    // If any requirement has rejected -> rejected
    // else if any pending or submitted (no approval) -> pending
    // else if all approved -> approved
    bool anyRejected = false;
    bool allApproved = requirements.isNotEmpty;
    bool anyPending = false;

    for (final r in requirements) {
      final list = docsByRequirement[r.id] ?? const <ClearanceDocument>[];
      final doc = list.isNotEmpty ? list.first : null; // most recent
      if (doc == null) {
        allApproved = false;
        continue;
      }
      switch (doc.status) {
        case ClearanceStatusEnum.rejected:
          anyRejected = true;
          allApproved = false;
          break;
        case ClearanceStatusEnum.approved:
          // keep allApproved unless contradicted elsewhere
          break;
        default:
          anyPending = true;
          allApproved = false;
      }
    }

    if (anyRejected) {
      unitStatus.value = ClearanceStatusEnum.rejected;
    } else if (allApproved) {
      unitStatus.value = ClearanceStatusEnum.approved;
    } else if (anyPending) {
      unitStatus.value = ClearanceStatusEnum.pending;
    } else {
      // No submissions for any requirement -> no banner
      unitStatus.value = null;
    }
  }

  Future<void> pickFileForRequirement(String requirementId) async {
    final req = requirements.firstWhereOrNull((r) => r.id == requirementId);
    if (req == null) return;

    // If already approved (latest doc), do not allow more uploads
    final latest = (docsByRequirement[requirementId] ?? const [])
        .cast<ClearanceDocument>()
        .toList();
    if (latest.isNotEmpty &&
        latest.first.status == ClearanceStatusEnum.approved) {
      Get.snackbar(
        'Not allowed',
        'This requirement has been approved already.',
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      // Only PDF is accepted
      allowedExtensions: const ['pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final current = selectedFiles[requirementId] ?? <PlatformFile>[];
      // Filter to ensure only .pdf (guard in case platform adds others)
      final added = result.files
          .where((f) => f.extension?.toLowerCase() == 'pdf')
          .toList();
      selectedFiles[requirementId] = [...current, ...added];
    }
  }

  void clearSelected(String requirementId) {
    selectedFiles.remove(requirementId);
  }

  // void removeFile(String requirementId, int index) {
  //   final current = selectedFiles[requirementId];
  //   if (current != null && index >= 0 && index < current.length) {
  //     final updated = List<PlatformFile>.from(current);
  //     updated.removeAt(index);
  //     if (updated.isEmpty) {
  //       selectedFiles.remove(requirementId);
  //     } else {
  //       selectedFiles[requirementId] = updated;
  //     }
  //   }
  // }

  bool get canSubmit {
    // can submit if there is at least one selected file and nothing is approved being modified
    return selectedFiles.values.any((list) => list.isNotEmpty);
  }

  Future<void> submitSelected() async {
    if (!canSubmit) {
      Get.snackbar('Nothing to submit', 'Please add at least one document.');
      return;
    }

    final studentId = Get.find<AuthController>().currentUser.value?.id;
    final id = unitId.value;
    if (studentId == null || id == null) return;

    isSubmitting.value = true;
    try {
      for (final entry in selectedFiles.entries) {
        final requirementId = entry.key;
        final files = entry.value;
        if (files.isEmpty) continue;
        final req = requirements.firstWhere((r) => r.id == requirementId);
        for (final file in files) {
          Uint8List? bytes = file.bytes;
          if (bytes == null && file.path != null) {
            // Fallback to reading from disk when bytes are not provided (mobile/desktop)
            bytes = await File(file.path!).readAsBytes();
          }
          if (bytes == null) continue;
          await _service.upsertRequirementDocument(
            studentId: studentId,
            unitId: id,
            requirement: req,
            fileName: file.name,
            bytes: bytes,
          );
        }
      }

      // Clear local selections and reload docs
      selectedFiles.clear();
      await load();
      Get.snackbar('Submitted', 'Documents submitted for review.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void removeFile(String requirementId, int index) {
    final files = selectedFiles[requirementId];
    if (files == null || index < 0 || index >= files.length) return;
    files.removeAt(index);
    selectedFiles[requirementId] = List.from(files);
    selectedFiles.refresh();
  }

  Future<void> previewFile(String requirementId, int index) async {
    final files = selectedFiles[requirementId];
    if (files == null || index < 0 || index >= files.length) return;
    final file = files[index];

    if (file.path != null) {
      await OpenFilex.open(file.path!);
    } else if (file.bytes != null) {
      final tmp = File('${Directory.systemTemp.path}/${file.name}');
      await tmp.writeAsBytes(file.bytes!);
      await OpenFilex.open(tmp.path);
    }
  }
}
