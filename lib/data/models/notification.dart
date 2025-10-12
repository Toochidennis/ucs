class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final bool read;
  final String userType;
  final DateTime? sentAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.read,
    required this.userType,
    this.sentAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        userId: json['user_id'],
        title: json['title'],
        message: json['message'],
        read: json['read'] ?? false,
        userType: json['user_type'],
        sentAt: json['sent_at'] != null
            ? DateTime.parse(json['sent_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'message': message,
        'read': read,
        'user_type': userType,
        'sent_at': sentAt?.toIso8601String(),
      };
}
