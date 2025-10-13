import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

      print('user $user');

      if (user != null) {
        currentUser.value = user;

        // Save user to storage
        final box = GetStorage();
        box.write('user', user.toJson());

        // Navigate by role
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
      passwordError.value = _parseError(e);
    } finally {
      isLoading.value = false;
    }
  }

  String _parseError(dynamic error) {
    final message = error.toString().toLowerCase();
    if (message.contains('network') ||
        message.contains('socket') ||
        message.contains('timeout')) {
      return 'Network error. Please check your connection.';
    } else if (message.contains('unauthorized') ||
        message.contains('invalid') ||
        message.contains('401')) {
      return 'Invalid credentials. Try again.';
    } else if (message.contains('500') || message.contains('server')) {
      return 'Server error. Please try again later.';
    } else {
      print(error);
      return 'Something went wrong. Please try again.';
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

  // Future<void> _updateFcmToken(Login user) async {
  //   // For example:
  //   // await repo.updateFcmToken(user.id, newToken, user.userType);
  // }

  Future<void> logout() async {
    try {
      await repo.logout();
      currentUser.value = null;
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
