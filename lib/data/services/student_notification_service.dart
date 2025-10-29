import 'package:ucs/data/repositories/student_notification_repository.dart';

class StudentNotificationService {
  final _repo = StudentNotificationRepository();

  /// Fetch notifications for a student with enriched data
  Future<List<Map<String, dynamic>>> getNotificationsForStudent(
    String studentId,
  ) async {
    return await _repo.getStudentNotifications(studentId);
  }

  /// Mark a specific notification as read
  Future<void> markAsRead(String notificationId) async {
    await _repo.markNotificationAsRead(notificationId);
  }

  /// Mark all student notifications as read
  Future<void> markAllAsRead(String studentId) async {
    await _repo.markAllNotificationsAsRead(studentId);
  }
}
