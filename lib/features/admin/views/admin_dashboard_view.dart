import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/admin/views/admin_settings_view.dart';
import 'package:ucs/features/admin/views/home_view.dart';
import 'package:ucs/features/admin/views/officers_view.dart';
import 'package:ucs/features/admin/views/workflow_view.dart';
import 'package:ucs/features/admin/views/students_view.dart';
import '../controllers/admin_controller.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Get.toNamed('/admin/settings'),
          ),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentTab.value,
          children: const [
            HomeView(),
            StudentsView(),
            OfficersView(),
            WorkflowView(),
            AdminSettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentTab.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "Students",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Officers",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: "Workflow"),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
