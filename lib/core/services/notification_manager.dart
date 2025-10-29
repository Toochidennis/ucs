import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/data/models/app_notification.dart';
import 'package:ucs/data/repositories/notification_repository.dart';

/// Universal Notification Manager for all user types
/// Handles real-time notification listening and unread count tracking
class NotificationManager extends GetxController {
  final _repo = NotificationRepository();
  final _client = Supabase.instance.client;

  // Observable unread count - accessible by all dashboards
  final unreadCount = 0.obs;

  // Current user ID
  String? _userId;

  // Realtime subscription
  RealtimeChannel? _subscription;

  /// Initialize the notification manager for a user
  void initialize(String userId) {
    if (_userId == userId) return; // Already initialized

    _userId = userId;
    _fetchUnreadCount();
    _setupRealtimeListener();
  }

  /// Fetch initial unread notification count
  Future<void> _fetchUnreadCount() async {
    if (_userId == null) return;

    try {
      final notifications = await _repo.getUserNotifications(_userId!);
      unreadCount.value = notifications.where((n) => !n.isRead).length;
    } catch (e) {
      // Silently fail - count will be 0
    }
  }

  /// Setup realtime listener for new notifications
  void _setupRealtimeListener() {
    if (_userId == null) return;

    // Remove old subscription if exists
    _subscription?.unsubscribe();

    // Listen to INSERT and UPDATE events on notifications table
    _subscription = _client
        .channel('notifications:$_userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId,
          ),
          callback: (payload) {
            // New notification received
            _handleNewNotification(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId,
          ),
          callback: (payload) {
            // Notification updated (e.g., marked as read)
            _handleNotificationUpdate(payload.newRecord);
          },
        )
        .subscribe();
  }

  /// Handle new notification
  void _handleNewNotification(Map<String, dynamic> data) {
    try {
      final notification = AppNotification.fromJson(data);
      if (!notification.isRead) {
        unreadCount.value++;
      }
    } catch (e) {
      // Parse error - ignore
    }
  }

  /// Handle notification update
  void _handleNotificationUpdate(Map<String, dynamic> data) {
    try {
      // Refresh count when notification is marked as read
      _fetchUnreadCount();
    } catch (e) {
      // Parse error - ignore
    }
  }

  /// Mark a notification as read and update count
  Future<void> markAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);

      // Count will be updated via realtime listener
      // But we can also manually decrement for immediate UI update
      if (unreadCount.value > 0) {
        unreadCount.value--;
      }
    } catch (e) {
      // Error marking as read
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (_userId == null) return;

    try {
      await _repo.markAllAsRead(_userId!);
      unreadCount.value = 0;
    } catch (e) {
      // Error marking all as read
    }
  }

  /// Refresh unread count manually
  Future<void> refreshCount() async {
    await _fetchUnreadCount();
  }

  /// Dispose and cleanup
  @override
  void onClose() {
    _subscription?.unsubscribe();
    super.onClose();
  }

  /// Reset manager (e.g., on logout)
  void reset() {
    _subscription?.unsubscribe();
    _userId = null;
    unreadCount.value = 0;
  }
}
