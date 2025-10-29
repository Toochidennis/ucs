import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/services/student_home_service.dart';

class StudentHomeController extends GetxController {
  final _service = StudentHomeService();
  final _storage = GetStorage();

  // Observables
  final isLoading = false.obs;
  final clearedCount = 0.obs;
  final unclearedCount = 0.obs;
  final progressList = <Map<String, dynamic>>[].obs;
  final recentActivities = <Map<String, dynamic>>[].obs;
  final studentName = ''.obs;
  final studentId = ''.obs;
  final studentStatus = Rxn<StudentStatus>();

  @override
  void onInit() {
    super.onInit();
    _loadStudentIdFromStorage();
    loadHomeData();
  }

  /// Load student ID from persisted data
  void _loadStudentIdFromStorage() {
    try {
      final userData = _storage.read('user');
      if (userData != null) {
        final user = Login.fromJson(Map<String, dynamic>.from(userData));
        studentId.value = user.id;
      }
    } catch (e) {
      // Failed to load student ID from storage
    }
  }

  /// Fetch student information from the server and update persisted data
  Future<void> _fetchStudentInfoFromServer() async {
    try {
      final studentData = await _service.getStudentInfo(studentId.value);

      // Build full name
      final firstName = studentData['first_name'] as String? ?? '';
      final middleName = studentData['middle_name'] as String? ?? '';
      final lastName = studentData['last_name'] as String? ?? '';
      final fullName =
          '$firstName ${middleName.isNotEmpty ? '$middleName ' : ''}$lastName'
              .trim();

      studentName.value = fullName.isNotEmpty ? fullName : 'Student';

      // Update status
      studentStatus.value = StudentStatusExtension.fromString(
        studentData['status'] as String?,
      );

      // Update persisted data
      final userData = _storage.read('user');
      if (userData != null) {
        final user = Login.fromJson(Map<String, dynamic>.from(userData));
        // Update the raw data with latest info from server
        user.raw['status'] = studentData['status'];
        user.raw['first_name'] = firstName;
        user.raw['middle_name'] = middleName;
        user.raw['last_name'] = lastName;

        // Save updated user data back to storage
        _storage.write('user', user.toJson());
      }
    } catch (e) {
      // If fetching from server fails, try to load from storage as fallback
      final userData = _storage.read('user');
      if (userData != null) {
        final user = Login.fromJson(Map<String, dynamic>.from(userData));
        studentName.value = user.displayName;

        final rawData = user.raw;
        if (rawData.containsKey('status')) {
          studentStatus.value = StudentStatusExtension.fromString(
            rawData['status'] as String?,
          );
        }
      } else {
        studentName.value = 'Student';
      }
    }
  }

  /// Load all home data - OPTIMIZED VERSION
  /// Fetches student info and home data in parallel
  Future<void> loadHomeData() async {
    if (studentId.value.isEmpty) {
      _loadStudentIdFromStorage();
      if (studentId.value.isEmpty) return;
    }

    isLoading.value = true;
    try {
      // Fetch student info and home data IN PARALLEL for faster loading
      final results = await Future.wait([
        _fetchStudentInfoFromServer(),
        _service.getHomeData(studentId.value),
      ]);

      final data = results[1] as Map<String, dynamic>;

      clearedCount.value = data['clearedCount'] as int;
      unclearedCount.value = data['unclearedCount'] as int;
      progressList.assignAll(data['progress'] as List<Map<String, dynamic>>);
      recentActivities.assignAll(
        data['activities'] as List<Map<String, dynamic>>,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load home data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh home data
  Future<void> refreshData() async {
    await loadHomeData();
  }

  /// Get button text based on clearance status
  String get buttonText {
    if (progressList.isEmpty) return 'Start Clearance Process';

    final allCompleted = progressList.every(
      (item) => item['status'] == 'approved',
    );
    final anyStarted = progressList.any(
      (item) => item['status'] != 'not_started',
    );

    if (allCompleted) {
      return 'Download Certificate';
    } else if (anyStarted) {
      return 'Continue Clearance Process';
    } else {
      return 'Start Clearance Process';
    }
  }

  /// Get welcome message based on clearance status
  String get welcomeMessage {
    if (progressList.isEmpty) return 'Complete your clearance process';

    final allCompleted = progressList.every(
      (item) => item['status'] == 'approved',
    );

    if (allCompleted) {
      return 'Congratulations! You have completed all clearance units';
    } else {
      return 'Complete your clearance process';
    }
  }

  /// Check if all clearance units are completed
  bool get isAllCompleted {
    if (progressList.isEmpty) return false;
    return progressList.every((item) => item['status'] == 'approved');
  }

  /// Check if student is suspended
  bool get isSuspended {
    return studentStatus.value == StudentStatus.suspended;
  }

  /// Handle button click - Navigate to appropriate clearance unit
  void onContinuePressed() {
    // Check if student is suspended
    if (isSuspended) {
      Get.snackbar(
        'Account Suspended',
        'Your account has been suspended. Please contact the admin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (progressList.isEmpty) {
      Get.snackbar(
        'No Units',
        'No clearance units available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // If all completed, download certificate
    if (isAllCompleted) {
      _downloadCertificate();
      return;
    }

    // Find the first unit that needs attention
    Map<String, dynamic>? targetUnit;

    // First, check for rejected units
    targetUnit = progressList.firstWhereOrNull(
      (item) => item['status'] == 'rejected',
    );

    // If no rejected, check for pending units
    targetUnit ??= progressList.firstWhereOrNull(
      (item) => item['status'] == 'pending',
    );

    // If no pending, get the first not started unit
    targetUnit ??= progressList.firstWhereOrNull(
      (item) => item['status'] == 'not_started',
    );

    // Navigate to the target unit
    if (targetUnit != null) {
      _navigateToUnit(targetUnit);
    }
  }

  /// Navigate to a specific clearance unit
  void _navigateToUnit(Map<String, dynamic> unit) {
    // TODO: Navigate to clearance detail view with unit data
    // For now, show a snackbar
    Get.snackbar(
      'Opening Unit',
      'Opening ${unit['unitName']}',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Uncomment when clearance detail view is ready
    // Get.toNamed(
    //   AppRoutes.clearanceDetail,
    //   arguments: {
    //     'unitId': unit['unitId'],
    //     'unitName': unit['unitName'],
    //     'status': unit['status'],
    //   },
    // );
  }

  /// Download certificate when all units are completed
  void _downloadCertificate() {
    // TODO: Implement certificate download
    Get.snackbar(
      'Success',
      'Certificate download will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
