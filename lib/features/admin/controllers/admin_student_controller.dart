import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/data/models/student.dart';
import 'package:ucs/data/services/student_service.dart';
import 'package:ucs/data/models/enums.dart';

class AdminStudentController extends GetxController {
  final _service = StudentService();
  final students = <Map<String, String>>[].obs; // filtered for UI
  final query = ''.obs;
  final isBusy = false.obs; // action overlay
  final isLoading = false.obs; // list loading state

  // Keep an unfiltered copy for search
  final List<Map<String, String>> _allStudents = [];

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    isLoading.value = true;
    try {
      final fetchedStudents = await _service.getStudents();
      final mapped = fetchedStudents.map((student) {
        return <String, String>{
          "id": student.id,
          "name": getStudentFullName(student),
          "matricNo": student.matricNo,
          "department": student.department,
          "faculty": student.faculty,
          "level": student.level,
          "email": student.email ?? '',
          "phone": student.phoneNumber ?? '',
          "gender": student.gender.value,
          "status": student.status.value,
        };
      }).toList();
      _allStudents
        ..clear()
        ..addAll(mapped);
      _applyFilter();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to load students. Please try again later.",
        backgroundColor: Colors.red[50],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getStudentFullName(Student student) {
    return "${student.firstName.trim()} ${student.middleName?.trim() ?? ""} ${student.lastName.trim()}";
  }

  void search(String q) {
    query.value = q;
    _applyFilter();
  }

  void _applyFilter() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      students.assignAll(_allStudents);
      return;
    }
    students.assignAll(
      _allStudents.where((s) {
        final name = (s['name'] ?? '').toLowerCase();
        final matric = (s['matricNo'] ?? '').toLowerCase();
        final dept = (s['department'] ?? '').toLowerCase();
        return name.contains(q) || matric.contains(q) || dept.contains(q);
      }),
    );
  }

  Future<void> resetStudentPasswordById(String id, String newPassword) async {
    await _withOverlay(() async {
      await _service.resetStudentPassword(id, newPassword);
      Get.snackbar(
        "Password Reset",
        "Password updated successfully.",
        backgroundColor: Colors.green[50],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

  Future<void> deleteStudentById(String id) async {
    await _withOverlay(() async {
      await _service.removeStudent(id);
      _allStudents.removeWhere((s) => s['id'] == id);
      students.removeWhere((s) => s['id'] == id);
      Get.snackbar(
        "Deleted",
        "Student removed successfully.",
        backgroundColor: Colors.green[50],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

  Future<void> changeStudentStatusById(String id, StudentStatus status) async {
    await _withOverlay(() async {
      await _service.updateStudentStatus(id, status);
      // Update local caches
      for (final s in _allStudents) {
        if (s['id'] == id) s['status'] = status.value;
      }
      _applyFilter();
      Get.snackbar(
        "Status Updated",
        "Student marked as ${status.value}.",
        backgroundColor: Colors.green[50],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

  Future<void> _withOverlay(Future<void> Function() action) async {
    isBusy.value = true;
    showDialog(
      context: Get.context!,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => Center(
        child: SpinKitChasingDots(color: AppColor.lightPrimary, size: 48),
      ),
    );
    try {
      await action();
    } finally {
      isBusy.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      } else {
        try {
          Navigator.of(Get.context!, rootNavigator: true).pop();
        } catch (_) {}
      }
    }
  }
}
