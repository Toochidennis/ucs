import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/routes/app_routes.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final repo = AuthRepository();

  final idCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  var isLoading = false.obs;
  var hidePassword = true.obs;
  var currentUser = Rxn<Login>();

  var idError = RxnString();
  var passwordError = RxnString();

  void togglePassword() => hidePassword.value = !hidePassword.value;

  bool _validateInputs() {
    idError.value = null;
    passwordError.value = null;

    final id = idCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (id.isEmpty) idError.value = 'Enter matric number or email';
    if (password.isEmpty) passwordError.value = 'Enter your password';

    return idError.value == null && passwordError.value == null;
  }

  Future<void> login() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final user = await repo.login(
        idCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (user != null) {
        currentUser.value = user;

        if (user.isAdmin) {
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else if (user.isOfficer) {
          Get.offAllNamed(AppRoutes.officerDashboard);
        } else {
          Get.offAllNamed(AppRoutes.studentDashboard);
        }
      } else {
        passwordError.value = 'Invalid credentials';
      }
    } catch (e) {
      passwordError.value = 'Login error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void _clearErrorsOnInput() {
    idCtrl.addListener(() {
      if (idError.value != null && idCtrl.text.trim().isNotEmpty) {
        idError.value = null;
      }
    });
    passwordCtrl.addListener(() {
      if (passwordError.value != null && passwordCtrl.text.trim().isNotEmpty) {
        passwordError.value = null;
      }
    });
  }

  Future<void> _updateFcmToken(Login user) async {
    // For example:
    // await repo.updateFcmToken(user.id, newToken, user.userType);
  }

  Future<void> logout() async {
    try {
      await repo.logout();
      currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (_) {}
  }

  @override
  void onInit() {
    super.onInit();
    _clearErrorsOnInput();
  }

  @override
  void onClose() {
    idCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
