import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/routes/app_routes.dart';
import 'package:ucs/features/admin/controllers/admin_student_controller.dart';
import 'package:ucs/features/admin/controllers/admin_officer_controller.dart';

class AdminDashboardController extends GetxController {
  // DateTime? lastBackPress;

  final currentTab = 0.obs;
  var appBarTitle = 'Dashboard'.obs;
  RxList<Widget> appBarActions = <Widget>[
    IconButton(
      onPressed: () => {},
      icon: const Icon(Icons.notifications, color: AppColor.lightPrimary),
    ),
  ].obs;

  void changeTab(int index) {
    currentTab.value = index;

    switch (index) {
      case 0:
        appBarTitle.value = 'Dashboard';
        appBarActions.value = [
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.notifications, color: AppColor.lightPrimary),
          ),
        ];
        break;

      case 1:
        appBarTitle.value = 'Student Management';
        appBarActions.value = [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final res = await Get.toNamed(AppRoutes.addStudent);
              if (res == true && Get.isRegistered<AdminStudentController>()) {
                // Refresh the students list on return if any were added
                Get.find<AdminStudentController>().fetchStudents();
              }
            },
          ),
        ];
        break;

      case 2:
        appBarTitle.value = 'Officer Management';
        appBarActions.value = [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final res = await Get.toNamed(AppRoutes.addOfficer);
              if (res == true && Get.isRegistered<AdminOfficerController>()) {
                Get.find<AdminOfficerController>().loadOfficers();
              }
            },
          ),
        ];
        break;

      case 3:
        appBarTitle.value = 'Clearance Workflow';
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
