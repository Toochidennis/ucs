import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/core/services/notification_manager.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/services/student_notification_service.dart';

class StudentNotificationController extends GetxController {
  final _service = StudentNotificationService();
  final _storage = GetStorage();

  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final studentId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStudentIdFromStorage();
    loadNotifications();
  }

  /// Load student ID from persisted data
  void _loadStudentIdFromStorage() {
    try {
      final userData = _storage.read('user');
      if (userData != null) {
        final user = Login.fromJson(Map<String, dynamic>.from(userData));
        studentId.value = user.id;
      }
    } catch (e) {
      // Failed to load student ID
    }
  }

  /// Load notifications from the database
  Future<void> loadNotifications() async {
    if (studentId.value.isEmpty) {
      _loadStudentIdFromStorage();
      if (studentId.value.isEmpty) return;
    }

    isLoading.value = true;
    try {
      final notifs = await _service.getNotificationsForStudent(studentId.value);

      // Process notifications and add UI properties
      final processedNotifs = notifs.map((notif) {
        return {
          ...notif,
          'icon': _getIconForNotification(notif['title']),
          'color': _getColorForNotification(notif['isRead'], notif['title']),
          'isNew': !notif['isRead'] && _isRecent(notif['sentAt']),
          'isOld': _isOld(notif['sentAt']),
        };
      }).toList();

      notifications.assignAll(processedNotifs);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load notifications: $e',
        backgroundColor: Colors.red[50],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (studentId.value.isEmpty) return;

    try {
      await _service.markAllAsRead(studentId.value);

      // Update local state
      for (var notif in notifications) {
        notif['isRead'] = true;
        notif['isNew'] = false;
        notif['color'] = Colors.grey;
      }
      notifications.refresh();

      // Update notification manager count
      try {
        final manager = Get.find<NotificationManager>(tag: studentId.value);
        manager.markAllAsRead();
      } catch (e) {
        // Manager not found
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark notifications as read',
        backgroundColor: Colors.red[50],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Mark a single notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);

      // Update local state
      final index = notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        notifications[index]['isRead'] = true;
        notifications[index]['isNew'] = false;
        notifications[index]['color'] = Colors.grey;
        notifications.refresh();
      }

      // Update notification manager count
      try {
        final manager = Get.find<NotificationManager>(tag: studentId.value);
        manager.markAsRead(notificationId);
      } catch (e) {
        // Manager not found
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark notification as read',
        backgroundColor: Colors.red[50],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  /// Get icon based on notification title/type
  IconData _getIconForNotification(String title) {
    final lowerTitle = title.toLowerCase();

    if (lowerTitle.contains('approved')) {
      return Icons.check_circle;
    } else if (lowerTitle.contains('rejected')) {
      return Icons.cancel;
    } else if (lowerTitle.contains('review') ||
        lowerTitle.contains('progress')) {
      return Icons.access_time;
    } else if (lowerTitle.contains('document') ||
        lowerTitle.contains('upload')) {
      return Icons.description;
    } else if (lowerTitle.contains('deadline') ||
        lowerTitle.contains('reminder')) {
      return Icons.info_outline;
    } else if (lowerTitle.contains('welcome')) {
      return Icons.person_add_alt;
    } else {
      return Icons.notifications;
    }
  }

  /// Get color based on read status and notification type
  Color _getColorForNotification(bool isRead, String title) {
    if (isRead) {
      return Colors.grey;
    }

    final lowerTitle = title.toLowerCase();

    if (lowerTitle.contains('approved')) {
      return Colors.green;
    } else if (lowerTitle.contains('rejected')) {
      return Colors.red;
    } else if (lowerTitle.contains('review') ||
        lowerTitle.contains('progress')) {
      return Colors.orange;
    } else if (lowerTitle.contains('document') ||
        lowerTitle.contains('upload')) {
      return Colors.deepOrange;
    } else if (lowerTitle.contains('deadline')) {
      return Colors.amber;
    } else {
      return Colors.blue;
    }
  }

  /// Check if notification is recent (within last hour)
  bool _isRecent(DateTime? sentAt) {
    if (sentAt == null) return false;
    final difference = DateTime.now().difference(sentAt);
    return difference.inHours < 1;
  }

  /// Check if notification is old (more than 7 days)
  bool _isOld(DateTime? sentAt) {
    if (sentAt == null) return false;
    final difference = DateTime.now().difference(sentAt);
    return difference.inDays > 7;
  }
}
