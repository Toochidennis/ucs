import 'package:ucs/data/models/enums.dart';
import 'package:uuid/uuid.dart';

class UserDevice {
  final String id;
  final String userId;
  final UserRole userRole;
  final String fcmToken;
  final String? deviceName;
  final String? platform;
  final DateTime? lastActive;
  final DateTime? createdAt;

  UserDevice({
    required this.id,
    required this.userId,
    required this.userRole,
    required this.fcmToken,
    this.deviceName,
    this.platform,
    this.lastActive,
    this.createdAt,
  });

  factory UserDevice.newDevice({
    required String userId,
    required UserRole userRole,
    required String fcmToken,
    String? deviceName,
    String? platform,
  }) {
    return UserDevice(
      id: const Uuid().v4(),
      userId: userId,
      userRole: userRole,
      fcmToken: fcmToken,
      deviceName: deviceName,
      platform: platform,
      lastActive: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  factory UserDevice.fromJson(Map<String, dynamic> json) => UserDevice(
    id: json['id'],
    userId: json['user_id'],
    userRole: UserRoleExtension.fromString(json['user_role']),
    fcmToken: json['fcm_token'],
    deviceName: json['device_name'],
    platform: json['platform'],
    lastActive: json['last_active'] != null
        ? DateTime.parse(json['last_active'])
        : null,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'user_role': userRole,
    'fcm_token': fcmToken,
    'device_name': deviceName,
    'platform': platform,
    'last_active': lastActive?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
  };
}
