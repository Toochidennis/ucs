import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/officer/controllers/officer_dashboard_controller.dart';
import 'package:ucs/features/officer/views/officer_home_view.dart';
import 'package:ucs/features/officer/views/officer_notifications_view.dart';
import 'package:ucs/features/officer/views/officer_profile_view.dart';

class OfficerDashboardView extends GetView<OfficerDashboardController> {
  const OfficerDashboardView({super.key});

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
                OfficerHomeView(),
                OfficerNotificationsView(),
                OfficerProfileView(),
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentTab.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: _buildNotificationIcon(false),
                  activeIcon: _buildNotificationIcon(true),
                  label: "Notifications",
                ),
                const BottomNavigationBarItem(
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

  /// Build notification icon with badge
  Widget _buildNotificationIcon(bool isActive) {
    return Obx(() {
      final count = controller.notificationManager.unreadCount.value;
      return Badge(
        label: Text(count > 99 ? '99+' : count.toString()),
        isLabelVisible: count > 0,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        child: Icon(
          isActive ? Icons.notifications : Icons.notifications_outlined,
        ),
      );
    });
  }
}
