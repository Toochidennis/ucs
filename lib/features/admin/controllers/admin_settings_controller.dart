import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/models/settings.dart';
import 'package:ucs/data/services/settings_service.dart';
import 'package:ucs/data/services/officer_service.dart';
import 'package:ucs/features/auth/controllers/auth_controller.dart';
import 'package:ucs/data/services/supabase_service.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class AdminSettingsController extends GetxController {
  final _settingsService = SettingsService();
  final _officerService = OfficerService();

  // Logged-in user
  final currentUser = Rxn<Login>();

  // Profile fields (display only; user-managed elsewhere)
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // School/Settings fields
  final schoolName = ''.obs;
  final session = ''.obs;
  final semester = ''.obs;
  final autoApprove = false.obs;
  final clearanceDeadline = Rxn<DateTime>();
  final contactEmail = ''.obs;
  final contactPhone = ''.obs;
  final schoolNameCtrl = TextEditingController();
  final sessionCtrl = TextEditingController();
  final semesterCtrl = TextEditingController();
  final contactEmailCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();
  final logoUrl = ''.obs;

  // App version
  final appVersion = '—'.obs;

  // Backing data
  final settings = Rxn<Settings>();
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadAppVersion();
    _loadSettings();
  }

  void _loadUser() {
    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      currentUser.value = auth.currentUser.value;
      final raw = Map<String, dynamic>.from(currentUser.value?.raw ?? {});
      name.value = raw['name'] ?? currentUser.value?.displayName ?? '';
      email.value = raw['email'] ?? '';
      phone.value = raw['phone_number'] ?? '';
      nameCtrl.text = name.value;
      emailCtrl.text = email.value;
      phoneCtrl.text = phone.value;
    }
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion.value = '${info.version}+${info.buildNumber}';
    } catch (_) {}
  }

  Future<void> _loadSettings() async {
    final s = await _settingsService.getSettings();
    settings.value = s;
    if (s != null) {
      schoolName.value = s.schoolName;
      session.value = s.session ?? '';
      semester.value = s.semester ?? '';
      autoApprove.value = s.autoApproveClearance;
      clearanceDeadline.value = s.clearanceDeadline;
      contactEmail.value = s.contactEmail ?? '';
      contactPhone.value = s.contactPhone ?? '';
      logoUrl.value = s.logoUrl ?? '';

      // Populate controllers so UI reflects loaded values
      schoolNameCtrl.text = schoolName.value;
      sessionCtrl.text = session.value;
      semesterCtrl.text = semester.value;
      contactEmailCtrl.text = contactEmail.value;
      contactPhoneCtrl.text = contactPhone.value;
    }
  }

  Future<void> pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final initial = clearanceDeadline.value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) clearanceDeadline.value = picked;
  }

  Future<void> saveSettings() async {
    final context = Get.overlayContext;
    if (context == null) return;
    isSaving.value = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: SpinKitChasingDots(color: AppColor.lightPrimary, size: 48),
      ),
    );
    try {
      final saved = await _settingsService.saveSettings(
        existing: settings.value,
        schoolName: schoolNameCtrl.text.trim(),
        session: sessionCtrl.text.trim().isEmpty
            ? null
            : sessionCtrl.text.trim(),
        semester: semesterCtrl.text.trim().isEmpty
            ? null
            : semesterCtrl.text.trim(),
        autoApproveClearance: autoApprove.value,
        clearanceDeadline: clearanceDeadline.value,
        contactEmail: contactEmailCtrl.text.trim().isEmpty
            ? null
            : contactEmailCtrl.text.trim(),
        contactPhone: contactPhoneCtrl.text.trim().isEmpty
            ? null
            : contactPhoneCtrl.text.trim(),
        logoUrl: logoUrl.value.trim().isEmpty ? null : logoUrl.value.trim(),
      );
      settings.value = saved;
      Get.back();
      Get.snackbar(
        'Success',
        'Settings saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[50],
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to save settings. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[50],
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> pickAndUploadLogo() async {
    final context = Get.overlayContext;
    if (context == null) return;
    // Pick image
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    Uint8List? bytes = file.bytes;
    if (bytes == null && file.path != null) {
      try {
        bytes = await File(file.path!).readAsBytes();
      } catch (_) {}
    }
    if (bytes == null) {
      Get.snackbar(
        'Error',
        'Unable to read selected file',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[50],
      );
      return;
    }

    // Show loader
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: SpinKitChasingDots(color: AppColor.lightPrimary, size: 48),
      ),
    );

    try {
      const bucket = 'app-assets';
      final ext = (file.extension ?? 'png').toLowerCase();
      final fileName =
          'logos/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      await SupabaseService.storage
          .from(bucket)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(upsert: true, contentType: 'image/$ext'),
          );
      final publicUrl = SupabaseService.storage
          .from(bucket)
          .getPublicUrl(fileName);
      logoUrl.value = publicUrl;

      // Persist immediately
      final saved = await _settingsService.saveSettings(
        existing: settings.value,
        schoolName: schoolNameCtrl.text.trim().isEmpty
            ? (settings.value?.schoolName ?? '')
            : schoolNameCtrl.text.trim(),
        session: sessionCtrl.text.trim().isEmpty
            ? null
            : sessionCtrl.text.trim(),
        semester: semesterCtrl.text.trim().isEmpty
            ? null
            : semesterCtrl.text.trim(),
        autoApproveClearance: autoApprove.value,
        clearanceDeadline: clearanceDeadline.value,
        contactEmail: contactEmailCtrl.text.trim().isEmpty
            ? null
            : contactEmailCtrl.text.trim(),
        contactPhone: contactPhoneCtrl.text.trim().isEmpty
            ? null
            : contactPhoneCtrl.text.trim(),
        logoUrl: logoUrl.value,
      );
      settings.value = saved;
      Get.back();
      Get.snackbar(
        'Logo Updated',
        'School logo updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[50],
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to upload logo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[50],
      );
    }
  }

  Future<void> resetMyPassword(BuildContext context) async {
    final pwdCtrl = TextEditingController();
    final confCtrl = TextEditingController();
    await Get.defaultDialog(
      title: 'Reset Password',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: pwdCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'New Password'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: confCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Reset',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final p = pwdCtrl.text.trim();
        final c = confCtrl.text.trim();
        if (p.isEmpty || c.isEmpty) {
          Get.snackbar(
            'Error',
            'Both fields are required',
            backgroundColor: Colors.red[50],
          );
          return;
        }
        if (p.length < 6) {
          Get.snackbar(
            'Error',
            'Password must be at least 6 characters',
            backgroundColor: Colors.red[50],
          );
          return;
        }
        if (p != c) {
          Get.snackbar(
            'Error',
            'Passwords do not match',
            backgroundColor: Colors.red[50],
          );
          return;
        }
        Get.back();

        // Show overlay
        showDialog(
          context: context,
          useRootNavigator: true,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: SpinKitChasingDots(color: AppColor.lightPrimary, size: 48),
          ),
        );
        try {
          final id = currentUser.value?.id;
          if (id != null && id.isNotEmpty) {
            await _officerService.resetOfficerPassword(id, p);
            Get.back();
            Get.snackbar(
              'Password Reset',
              'Password updated successfully.',
              backgroundColor: Colors.green[50],
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.back();
            Get.snackbar(
              'Error',
              'No authenticated user found.',
              backgroundColor: Colors.red[50],
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } catch (_) {
          Get.back();
          Get.snackbar(
            'Error',
            'Failed to reset password.',
            backgroundColor: Colors.red[50],
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  void logout() {
    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      auth.logout();
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    schoolNameCtrl.dispose();
    sessionCtrl.dispose();
    semesterCtrl.dispose();
    contactEmailCtrl.dispose();
    contactPhoneCtrl.dispose();
    super.onClose();
  }
}
