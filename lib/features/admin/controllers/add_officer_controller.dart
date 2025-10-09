import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddOfficerController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Inputs
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final role = TextEditingController();
  final employeeId = TextEditingController();
  final password = TextEditingController();

  // Dropdowns
  final department = "".obs;

  // Toggles
  final canReview = false.obs;
  final officerStatus = true.obs;

  final showPassword = false.obs;

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