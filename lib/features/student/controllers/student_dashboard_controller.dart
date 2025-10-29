import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/core/services/notification_manager.dart';
import 'package:ucs/data/models/login.dart';

class StudentDashboardController extends GetxController {
  final _storage = GetStorage();
  late final NotificationManager notificationManager;

  var currentTab = 0.obs;
  var appBarTitle = 'Dashboard'.obs;
  RxList<Widget> appBarActions = <Widget>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeNotificationManager();
  }

  /// Initialize notification manager with current user
  void _initializeNotificationManager() {
    try {
      final userData = _storage.read('user');
      if (userData != null) {
        final user = Login.fromJson(Map<String, dynamic>.from(userData));
        notificationManager = Get.put(NotificationManager(), tag: user.id);
        notificationManager.initialize(user.id);
      }
    } catch (e) {
      // Failed to initialize notification manager
    }
  }

  void changeTab(int index) {
    currentTab.value = index;

    switch (index) {
      case 0:
        appBarTitle.value = 'Dashboard';
        appBarActions.value = [];
        break;

      case 1:
        appBarTitle.value = 'Clearance Process';
        appBarActions.value = [];
        break;

      case 2:
        appBarTitle.value = 'Notifications';
        appBarActions.value = [];
        break;

      case 3:
        appBarTitle.value = 'Profile';
        appBarActions.value = [];
        break;
    }
  }

  Future<void> handleBackPressed() async {
    if (currentTab.value != 0) {
      changeTab(0);
    } else {
      await SystemNavigator.pop();
    }
  }

  @override
  void onClose() {
    // Cleanup is handled by the notification manager itself
    super.onClose();
  }
}
