import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/admin_dashboard_controller.dart';
import 'package:ucs/features/admin/views/admin_settings_view.dart';
import 'package:ucs/features/admin/views/admin_home_view.dart';
import 'package:ucs/features/admin/views/admin_officer_view.dart';
import 'package:ucs/features/admin/views/workflow_view.dart';
import 'package:ucs/features/admin/views/admin_students_view.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) result;
        await controller.handleBackPressed();
      },
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.appBarTitle.value),
            actions: controller.appBarActions,
          ),
          body: Obx(
            () => IndexedStack(
              index: controller.currentTab.value,
              children: const [
                AdminHomeView(),
                StudentsView(),
                OfficersView(),
                WorkflowView(),
                AdminSettingsView(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentTab.value,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: "Students",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: "Officers",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: "Workflow",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        );
      }),
    );
  }
}
