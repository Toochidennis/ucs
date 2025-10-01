import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/admin/views/admin_home_view.dart';
import 'package:ucs/features/admin/views/officers_view.dart';
import 'package:ucs/features/admin/views/reports_view.dart';
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
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/admin/settings'),
          ),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentTab.value,
          children: const [
            AdminHomeView(),
            StudentsView(),
            OfficersView(),
            ReportsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentTab.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Home",
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
              icon: Icon(Icons.bar_chart),
              label: "Reports",
            ),
          ],
        ),
      ),
    );
  }
}
