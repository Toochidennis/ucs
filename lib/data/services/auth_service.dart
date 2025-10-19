import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/core/routes/app_routes.dart';
import 'package:ucs/core/utils/fcm_util.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/repositories/auth_repository.dart';
import 'package:ucs/data/services/user_device_service.dart';

class AuthService {
  final _repo = AuthRepository();
  final _deviceService = UserDeviceService();

  Future<Login?> login({
    required String identifier,
    required String password,
  }) async {
    final user = await _repo.login(identifier: identifier, password: password);

    if (user != null) {
      final token = await FcmUtil.getDeviceToken();

      debugPrint('token $token');

      if (token != null && token.isNotEmpty) {
        await _deviceService.registerDevice(
          userId: user.id,
          userRole: user.isAdmin
              ? UserRole.admin
              : user.isOfficer
              ? UserRole.officer
              : UserRole.student,
          fcmToken: token,
          platform: Platform.operatingSystem,
          deviceName: Platform.localHostname,
        );
      }
    }

    return user;
  }

  Future<void> logout(Login? user) async {
    if (user != null) {
      // Delete the token from DB and Firebase
      final token = await FcmUtil.getDeviceToken();
      if (token != null && token.isNotEmpty) {
        await _deviceService.removeDevice(user.id, token);
        await FcmUtil.deleteToken();
      }
    }

    await _repo.logout();
    GetStorage().erase();
    Get.offAllNamed(AppRoutes.login);
  }
}
