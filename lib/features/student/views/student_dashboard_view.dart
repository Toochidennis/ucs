import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/student_controller.dart';
import 'package:ucs/features/student/views/clearance_detail_view.dart';
import 'package:ucs/features/student/views/student_home_view.dart';
import 'package:ucs/features/student/views/student_profile_view.dart';
import 'package:ucs/shared/views/notifications_view.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';

class StudentDashboardView extends GetView<StudentController> {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 👤 Profile Icon (clickable)
              GestureDetector(
                onTap: () => Get.toNamed('/profile'), // ← your route here
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
              ),

              // 🏷 Dashboard Title
              Text("Dashboard", style: AppFont.titleSmall),

              // 🔔 Notification Icon with Badge (clickable)
              GestureDetector(
                onTap: () => Get.toNamed('/notifications'), // ← your route here
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: -1,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              icon: Icon(Icons.dashboard),
              activeIcon: Icon(Icons.home),
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
  }
}
