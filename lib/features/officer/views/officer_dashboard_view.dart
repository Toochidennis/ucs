import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/officer/controllers/officer_controller.dart';

class OfficerDashboardView extends GetView<OfficerController> {
  const OfficerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Officer Dashboard"),
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
            Center(child: Text('Home')),
            Center(child: Text('Home')),
            Center(child: Text('Home')),
            Center(child: Text('Home')),
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
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
