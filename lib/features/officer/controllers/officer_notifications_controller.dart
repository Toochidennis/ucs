import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  bool isNew;
  bool isOld;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    this.isNew = false,
    this.isOld = false,
  });
}

class OfficerNotificationsController extends GetxController {
  // Observable list of notifications
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyNotifications();
  }

  void _loadDummyNotifications() {
    notifications.assignAll([
      NotificationItem(
        id: 1,
        title: "Finance Clearance Approved",
        message:
            "Your finance clearance has been approved by the finance officer. You can now proceed to the next unit.",
        time: "15 minutes ago",
        icon: Icons.check,
        color: Colors.blue,
        isNew: true,
      ),
      NotificationItem(
        id: 2,
        title: "Library Review in Progress",
        message:
            "Your library clearance documents are currently being reviewed by Dr. Michael Thompson.",
        time: "2 hours ago",
        icon: Icons.access_time,
        color: Colors.orange,
      ),
      NotificationItem(
        id: 3,
        title: "Additional Documents Required",
        message:
            "The hostel officer has requested additional documentation for your clearance. Please upload the required files.",
        time: "1 day ago",
        icon: Icons.description,
        color: Colors.deepOrange,
      ),
      NotificationItem(
        id: 4,
        title: "Clearance Deadline Reminder",
        message:
            "Reminder: The clearance deadline is March 31, 2025. Please complete all pending clearances before the deadline.",
        time: "2 days ago",
        icon: Icons.info_outline,
        color: Colors.green,
      ),
      NotificationItem(
        id: 5,
        title: "Welcome to E-Clearance System",
        message:
            "Welcome to the university e-clearance system. Start your clearance process by completing your profile information.",
        time: "1 week ago",
        icon: Icons.person_add_alt,
        color: Colors.grey,
        isOld: true,
      ),
    ]);
  }

  // Mark all as read
  void markAllRead() {
    for (var n in notifications) {
      n.isNew = false;
    }
    notifications.refresh();
  }

  // Mark single notification as read
  void markAsRead(int id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isNew = false;
      notifications.refresh();
    }
  }
}
