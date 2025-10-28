import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/student_dashboard_controller.dart';
import 'package:ucs/features/student/views/clearance_detail_view.dart';
import 'package:ucs/features/student/views/student_home_view.dart';
import 'package:ucs/features/student/views/student_profile_view.dart';
import 'package:ucs/shared/views/notifications_view.dart';

class StudentDashboardView extends GetView<StudentDashboardController> {
  const StudentDashboardView({super.key});

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
                StudentHomeView(),
                ClearanceDetailView(),
                NotificationsView(),
                StudentProfileView(),
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentTab.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined),
                  activeIcon: Icon(Icons.article),
                  label: "Clearance",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined),
                  activeIcon: Icon(Icons.notifications),
                  label: "Notifications",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
