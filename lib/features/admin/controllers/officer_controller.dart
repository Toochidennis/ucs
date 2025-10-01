import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfficerController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Inputs
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final role = TextEditingController();
  final employeeId = TextEditingController();

  // Dropdowns
  final department = "".obs;

  // Toggles
  final canReview = false.obs;
  final canManageDocs = false.obs;
  final canSendNotif = false.obs;
  final canGenerateReports = false.obs;

  final officerStatus = true.obs;
  final emailNotif = true.obs;

  final startTime = TimeOfDay(hour: 8, minute: 0).obs;
  final endTime = TimeOfDay(hour: 17, minute: 0).obs;

  // Submit
  void saveOfficer() {
    if (formKey.currentState?.validate() ?? false) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Officer Added Successfully"),
          content: const Text(
              "The new officer has been added and will receive login credentials via email."),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text("Continue"),
            )
          ],
        ),
      );
    }
  }
}