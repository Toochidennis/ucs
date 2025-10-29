import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/data/models/app_notification.dart';

class StudentNotificationRepository {
  final _client = Supabase.instance.client;
  final String _notifTable = 'notifications';
  final String _officerTable = 'officers';
  final String _unitsTable = 'clearance_units';

  /// Get notifications for a student with enriched officer and unit information
  Future<List<Map<String, dynamic>>> getStudentNotifications(
    String studentId,
  ) async {
    try {
      // Fetch notifications for the student
      final notificationsRes = await _client
          .from(_notifTable)
          .select()
          .eq('user_id', studentId)
          .order('sent_at', ascending: false);

      final notifications = (notificationsRes as List)
          .map((e) => AppNotification.fromJson(e))
          .toList();

      // Collect unique user IDs from notifications (these are officer IDs)
      final officerIds = notifications
          .map((n) => n.userId)
          .where((id) => id != studentId)
          .toSet()
          .toList();

      // Fetch officer information for enrichment
      Map<String, Map<String, dynamic>> officersById = {};
      if (officerIds.isNotEmpty) {
        final officersRes = await _client
            .from(_officerTable)
            .select('id, name, unit_id')
            .inFilter('id', officerIds);

        for (final officer in (officersRes as List)) {
          officersById[officer['id']] = officer;
        }
      }

      // Collect unique unit IDs
      final unitIds = officersById.values
          .map((o) => o['unit_id'] as String?)
          .where((id) => id != null)
          .toSet()
          .toList();

      // Fetch unit information
      Map<String, String> unitsById = {};
      if (unitIds.isNotEmpty) {
        final unitsRes = await _client
            .from(_unitsTable)
            .select('id, unit_name')
            .inFilter('id', unitIds);

        for (final unit in (unitsRes as List)) {
          unitsById[unit['id']] = unit['unit_name'];
        }
      }

      // Build enriched notification list
      final enrichedNotifications = <Map<String, dynamic>>[];

      for (final notification in notifications) {
        final officer = officersById[notification.userId];
        final unitId = officer?['unit_id'] as String?;
        final unitName = unitId != null ? unitsById[unitId] : null;

        enrichedNotifications.add({
          'id': notification.id,
          'title': notification.title,
          'message': notification.message,
          'time': _formatTimeAgo(notification.sentAt),
          'isRead': notification.isRead,
          'sentAt': notification.sentAt,
          'officerName': officer?['name'],
          'unitName': unitName,
        });
      }

      return enrichedNotifications;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch notifications: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Mark a single notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _client
          .from(_notifTable)
          .update({'is_read': true})
          .eq('id', notificationId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to mark notification as read: ${e.message}');
    }
  }

  /// Mark all notifications as read for a student
  Future<void> markAllNotificationsAsRead(String studentId) async {
    try {
      await _client
          .from(_notifTable)
          .update({'is_read': true})
          .eq('user_id', studentId)
          .eq('is_read', false);
    } on PostgrestException catch (e) {
      throw Exception('Failed to mark all notifications as read: ${e.message}');
    }
  }

  /// Helper method to format time ago
  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
