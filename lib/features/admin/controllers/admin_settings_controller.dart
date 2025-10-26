import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSettingsController extends GetxController {
  // Profile
  final name = "John Mitchell".obs;
  final email = "admin@stateuniversity.edu".obs;
  final phone = "+1 (555) 123-4567".obs;

  // School Info
  final schoolName = "State University of Technology".obs;
  final academicYear = "2024-2025".obs;
  final semester = "Second Semester".obs;

  // Preferences
  final darkMode = false.obs;
  final emailNotif = true.obs;
  final inAppNotif = true.obs;
  final autoApprove = false.obs;

  void saveSettings() {
    Get.snackbar("Success", "Settings saved successfully",
        snackPosition: SnackPosition.BOTTOM);
  }

  void logout() {
    Get.snackbar("Logout", "Logging out...",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade100);
  }
}