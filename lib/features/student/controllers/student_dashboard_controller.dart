import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class StudentDashboardController extends GetxController {
  var currentTab = 0.obs;
  var appBarTitle = 'Dashboard'.obs;
  RxList<Widget> appBarActions = <Widget>[].obs;

  void changeTab(int index) {
    currentTab.value = index;

    switch (index) {
      case 0:
        appBarTitle.value = 'Dashboard';
        appBarActions.value = [];
        break;

      case 1:
        appBarTitle.value = 'Clearance Details';
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
}
