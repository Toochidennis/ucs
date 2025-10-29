import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/services/student_home_service.dart';

class ClearanceProcessController extends GetxController {
  final _service = StudentHomeService();
  final _storage = GetStorage();

  // Observables
  final isLoading = false.obs;
  final clearanceUnits = <Map<String, dynamic>>[].obs;
  final studentId = ''.obs;
  final allUnitsCleared = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStudentId();
    loadClearanceUnits();
  }

  /// Load student ID from storage
  void _loadStudentId() {
    try {
      final userData = _storage.read('user');
      if (userData != null) {
        final loginData = Login.fromJson(userData);
        studentId.value = loginData.id;
      }
    } catch (e) {
      debugPrint('Error loading student ID: $e');
    }
  }

  /// Load clearance units with their status for the student
  Future<void> loadClearanceUnits() async {
    if (studentId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Student ID not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Get units and their status
      final progressData = await _service.getClearanceProgress(studentId.value);

      // Transform data and determine accessibility
      final transformedUnits = <Map<String, dynamic>>[];
      bool previousCleared = true;

      for (int i = 0; i < progressData.length; i++) {
        final unit = progressData[i];
        final status = unit['status'] as String;

        // Unit is accessible if:
        // 1. It's the first unit, OR
        // 2. The previous unit is cleared (approved)
        final isAccessible = i == 0 || previousCleared;

        transformedUnits.add({
          'unitId': unit['unitId'],
          'unitName': unit['unitName'],
          'position': i + 1,
          'status': status,
          'icon': _getUnitIcon(status),
          'color': _getUnitColor(status),
          'isAccessible': isAccessible,
          'statusText': _getStatusText(status),
        });

        // Update previousCleared for next iteration
        previousCleared = status == 'approved';
      }

      clearanceUnits.assignAll(transformedUnits);

      // Check if all units are cleared
      allUnitsCleared.value =
          transformedUnits.isNotEmpty &&
          transformedUnits.every((unit) => unit['status'] == 'approved');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load clearance units: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh clearance units
  Future<void> refreshUnits() async {
    await loadClearanceUnits();
  }

  /// Handle unit card tap
  void onUnitTap(Map<String, dynamic> unit) {
    if (!(unit['isAccessible'] as bool)) {
      Get.snackbar(
        'Unit Locked',
        'Please complete the previous unit first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Navigate to unit detail view
    Get.snackbar(
      'Opening Unit',
      'Opening ${unit['unitName']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Handle certificate download
  void downloadCertificate() {
    if (!allUnitsCleared.value) {
      Get.snackbar(
        'Not Available',
        'Complete all clearance units to download certificate',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // TODO: Implement certificate download
    Get.snackbar(
      'Success',
      'Certificate download will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Get icon based on status
  IconData _getUnitIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  /// Get color based on status
  Color _getUnitColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Get status text
  String _getStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'Cleared';
      case 'rejected':
        return 'Issues Found';
      case 'pending':
        return 'Under Review';
      default:
        return 'Not Started';
    }
  }
}
