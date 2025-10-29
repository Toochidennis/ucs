import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/data/models/app_notification.dart';

class NotificationRepository {
  final _client = Supabase.instance.client;
  final String _notifTable = 'notifications';
  final String _deviceTable = 'user_devices';

  // Save notification record
  Future<void> createNotification(AppNotification notification) async {
    try {
      await _client.from(_notifTable).insert(notification.toJson());
    } on PostgrestException catch (e) {
      throw Exception('Failed to create notification: ${e.message}');
    }
  }

  // Get notifications for a specific user
  Future<List<AppNotification>> getUserNotifications(String userId) async {
    try {
      final res = await _client
          .from(_notifTable)
          .select()
          .eq('user_id', userId)
          .order('sent_at', ascending: false);

      return (res as List).map((e) => AppNotification.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch notifications: ${e.message}');
    }
  }

  // Mark all as read
  Future<void> markAllAsRead(String userId) async {
    try {
      await _client
          .from(_notifTable)
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update notifications: ${e.message}');
    }
  }

  Future<List<String>> getUserFcmTokens(String userId) async {
    try {
      final result = await _client
          .from(_deviceTable)
          .select('fcm_token')
          .eq('user_id', userId);

      return (result as List).map((e) => e['fcm_token'].toString()).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to get user FCM tokens: ${e.message}');
    }
  }
}
