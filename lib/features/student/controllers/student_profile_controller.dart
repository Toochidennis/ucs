import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/services/student_home_service.dart';

class StudentProfileController extends GetxController {
  final _storage = GetStorage();
  final _service = StudentHomeService();

  // Observables
  final isLoading = false.obs;
  final studentId = ''.obs;
  final firstName = ''.obs;
  final middleName = ''.obs;
  final lastName = ''.obs;
  final matricNo = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;
  final department = ''.obs;
  final faculty = ''.obs;
  final level = ''.obs;
  final gender = ''.obs;
  final status = Rxn<StudentStatus>();

  var pushNotifications = true.obs;
  var emailUpdates = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStudentIdFromStorage();
    loadStudentProfile();
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
      // Failed to load student ID
    }
  }

  /// Load student profile from server
  Future<void> loadStudentProfile() async {
    if (studentId.value.isEmpty) {
      _loadStudentIdFromStorage();
      if (studentId.value.isEmpty) return;
    }

    isLoading.value = true;
    try {
      final studentData = await _service.getStudentInfo(studentId.value);

      // Update observables
      firstName.value = studentData['first_name'] as String? ?? '';
      middleName.value = studentData['middle_name'] as String? ?? '';
      lastName.value = studentData['last_name'] as String? ?? '';
      matricNo.value = studentData['matric_no'] as String? ?? '';
      email.value = studentData['email'] as String? ?? '';
      phoneNumber.value = studentData['phone_number'] as String? ?? '';
      department.value = studentData['department'] as String? ?? '';
      faculty.value = studentData['faculty'] as String? ?? '';
      level.value = studentData['level'] as String? ?? '';
      gender.value = studentData['gender'] as String? ?? '';
      status.value = StudentStatusExtension.fromString(
        studentData['status'] as String?,
      );

      // Update persisted data
      final userData = _storage.read('user');
      if (userData != null) {
        final user = Login.fromJson(Map<String, dynamic>.from(userData));
        user.raw['first_name'] = firstName.value;
        user.raw['middle_name'] = middleName.value;
        user.raw['last_name'] = lastName.value;
        user.raw['matric_no'] = matricNo.value;
        user.raw['email'] = email.value;
        user.raw['phone_number'] = phoneNumber.value;
        user.raw['department'] = department.value;
        user.raw['faculty'] = faculty.value;
        user.raw['level'] = level.value;
        user.raw['gender'] = gender.value;
        user.raw['status'] = studentData['status'];

        _storage.write('user', user.toJson());
      }
    } catch (e) {
      // If server fails, try to load from storage as fallback
      _loadFromStorage();
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load from persisted storage as fallback
  void _loadFromStorage() {
    try {
      final userData = _storage.read('user');
      if (userData != null) {
        final user = Login.fromJson(Map<String, dynamic>.from(userData));
        final rawData = user.raw;

        firstName.value = rawData['first_name'] as String? ?? '';
        middleName.value = rawData['middle_name'] as String? ?? '';
        lastName.value = rawData['last_name'] as String? ?? '';
        matricNo.value = rawData['matric_no'] as String? ?? '';
        email.value = rawData['email'] as String? ?? '';
        phoneNumber.value = rawData['phone_number'] as String? ?? '';
        department.value = rawData['department'] as String? ?? '';
        faculty.value = rawData['faculty'] as String? ?? '';
        level.value = rawData['level'] as String? ?? '';
        gender.value = rawData['gender'] as String? ?? '';
        status.value = StudentStatusExtension.fromString(
          rawData['status'] as String?,
        );
      }
    } catch (e) {
      // Failed to load from storage
    }
  }

  /// Get full name
  String get fullName {
    final middle = middleName.value.isNotEmpty ? ' ${middleName.value}' : '';
    return '${firstName.value}$middle ${lastName.value}'.trim();
  }

  /// Get initials for avatar
  String get initials {
    if (firstName.value.isEmpty && lastName.value.isEmpty) return 'S';
    final first = firstName.value.isNotEmpty ? firstName.value[0] : '';
    final last = lastName.value.isNotEmpty ? lastName.value[0] : '';
    return '$first$last'.toUpperCase();
  }

  /// Get status display text - show actual status from server
  String get statusText {
    switch (status.value) {
      case StudentStatus.cleared:
        return 'Cleared';
      case StudentStatus.inProgress:
        return 'In Progress';
      case StudentStatus.suspended:
        return 'Suspended';
      case StudentStatus.pending:
        return 'Pending';
      default:
        return 'Active';
    }
  }

  /// Get status color using theme colors for light/dark mode support
  (Color, Color) getStatusColors(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    switch (status.value) {
      case StudentStatus.cleared:
        return (theme.secondaryContainer, theme.onSecondaryContainer);
      case StudentStatus.inProgress:
        return (theme.tertiaryContainer, theme.onTertiaryContainer);
      case StudentStatus.suspended:
        return (theme.errorContainer, theme.onErrorContainer);
      case StudentStatus.pending:
        return (theme.primaryContainer, theme.onPrimaryContainer);
      default:
        return (theme.primaryContainer, theme.onPrimaryContainer);
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await loadStudentProfile();
  }

  /// Called when "Edit" button in header is tapped
  void editProfile() {
    Get.toNamed('/student/profile/edit');
  }

  /// Toggle push notifications
  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  /// Toggle email updates
  void toggleEmailUpdates(bool value) {
    emailUpdates.value = value;
  }

  /// Handle logout
  void logout() {
    Get.offAllNamed('/auth/login');
  }
}
