import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudentController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final dob = TextEditingController();
  final studentId = TextEditingController();
  final major = TextEditingController();
  final enrollmentYear = TextEditingController();
  final graduationYear = TextEditingController();
  final faculty = "".obs;
  final department = "".obs;
  final advisor = TextEditingController();
  final password = TextEditingController();
  final accountStatus = "Active".obs;
  final gender = "Male".obs;

  // Reactive fields
  final showPassword = false.obs;
  final isFormValid = false.obs;

  // Faculties -> Departments
  final faculties = {
    "Engineering": [
      "Computer Science",
      "Mechanical Engineering",
      "Electrical Engineering",
    ],
    "Medicine": ["General Medicine", "Surgery", "Pediatrics"],
    "Law": ["Constitutional Law", "Criminal Law", "Corporate Law"],
  };
  Map<String, List<String>> get departments => faculties;

  void submitForm() {
    if (formKey.currentState!.validate()) {
      Get.snackbar("Success", "Student added successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    }
  }
}
