import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ucs/core/routes/app_routes.dart';

class AdminDashboardController extends GetxController {
 // DateTime? lastBackPress;

  final currentTab = 0.obs;
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
        appBarTitle.value = 'Student Management';
        appBarActions.value = [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(AppRoutes.addStudent),
          ),
        ];
        break;

      case 2:
        appBarTitle.value = 'Officer Management';
        appBarActions.value = [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed(AppRoutes.addOfficer),
          ),
        ];
        break;

      case 3:
        appBarTitle.value = 'Workflow Settings';
        appBarActions.value = [];
        break;

      case 4:
        appBarTitle.value = 'Settings';
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

    // final now = DateTime.now();
    // if (lastBackPress == null ||
    //     now.difference(lastBackPress!) > const Duration(seconds: 2)) {
    //   lastBackPress = now;
    //   Get.snackbar(
    //     "Exit",
    //     "Press back again to exit the app",
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return false;
    // }

    // return true; // exit
  }
}
