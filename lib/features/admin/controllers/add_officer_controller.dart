import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/services/officer_service.dart';
import 'package:ucs/core/constants/app_color.dart';

class AddOfficerController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _service = OfficerService();

  // Inputs
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final officerId = TextEditingController();
  final password = TextEditingController();
  final gender = "Male".obs;
  final unit = "".obs;

  // Toggles
  final canReview = false.obs;
  final showPassword = false.obs;

  final units = <ClearanceUnit>[].obs;
  // Track if any officer was added in this session; used to refresh list on return
  final addedAny = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUnits();
  }

  Future<void> loadUnits() async {
    try {
      final data = await _service.fetchUnits();
      units.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to load clearance units. Please try again later.",
        backgroundColor: Colors.red[50],
      );
    }
  }

  Future<void> saveOfficer() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => Center(
        child: SpinKitChasingDots(color: AppColor.lightPrimary, size: 48),
      ),
    );

    try {
      final selectedUnit = units.firstWhere(
        (u) => u.unitName == unit.value,
        orElse: () => throw Exception("Unit not selected"),
      );

      await _service.saveOfficer(
        name: fullName.text.trim(),
        email: email.text.trim().isEmpty ? null : email.text.trim(),
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
        officerId: officerId.text.trim(),
        password: password.text.trim(),
        gender: gender.value.toLowerCase() == 'male'
            ? Gender.male
            : Gender.female,
        role: UserRole.officer,
        canReview: canReview.value,
        unitId: selectedUnit.id,
      );

      // Close loading dialog first
      Get.back();

      // Brief delay to ensure overlay settles before showing snackbar
      await Future.delayed(const Duration(milliseconds: 75));

      Get.closeAllSnackbars();
      Get.snackbar(
        "Success",
        "Officer added successfully.",
        backgroundColor: Colors.green[50],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Stay on this page and clear the form for a new entry
      clearForm();
      // Mark that at least one officer was added
      addedAny.value = true;
    } catch (e) {
      Get.back(); // close loading

      String message = _parseError(e);
      Get.snackbar("Error", message, backgroundColor: Colors.red[50]);
    }
  }

  void clearForm() {
    // Unfocus any active input
    FocusManager.instance.primaryFocus?.unfocus();

    // Clear text fields
    fullName.clear();
    email.clear();
    phone.clear();
    officerId.clear();
    password.clear();

    // Reset dropdowns/toggles
    gender.value = "Male";
    unit.value = "";
    canReview.value = false;
    showPassword.value = false;

    // Reset form validation state
    formKey.currentState?.reset();
  }

  String _parseError(dynamic e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains("exists") || msg.contains("duplicate")) {
      return "An officer with this ID already exists.";
    } else if (msg.contains("network") ||
        msg.contains("timeout") ||
        msg.contains("socket")) {
      return "Network issue. Please check your connection.";
    } else if (msg.contains("unit not selected")) {
      return "Please select a valid clearance unit.";
    } else {
      return "Something went wrong while saving the officer. Please try again.";
    }
  }
}
