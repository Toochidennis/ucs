import 'package:ucs/data/models/app_notification.dart';
import 'package:ucs/data/repositories/notification_repository.dart';

class NotificationService {
  final _repo = NotificationRepository();

  /// Create and save a new notification in the database
  Future<void> sendNotification({
    required String userId,
    required String userType,
    required String title,
    required String message,
  }) async {
    final notif = AppNotification.newNotification(
      userId: userId,
      userType: userType,
      title: title,
      message: message,
    );

    await _repo.createNotification(notif);

    // Optionally, you could trigger FCM here (using Cloud Functions or API)
  }

  /// Fetch all notifications for a user
  Future<List<AppNotification>> getNotifications(String userId) async {
    return await _repo.getUserNotifications(userId);
  }

  /// Mark all notifications as read
  Future<void> markAsRead(String userId) async {
    await _repo.markAllAsRead(userId);
  }

  /// ✅ Get user’s active FCM tokens (multi-device)
  Future<List<String>> getUserTokens(String userId) async {
    return await _repo.getUserFcmTokens(userId);
  }
}
