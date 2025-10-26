import 'package:ucs/data/models/enums.dart';

class Officer {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? unitId;
  final String? unitName; // joined from clearance_units
  final String officerId;
  final Gender gender; // 'male', 'female', 'other'
  final UserRole role; // 'admin', 'officer'
  final String? fcmToken;
  final String password;
  final bool canReview;
  final DateTime createdAt;

  Officer({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    this.unitId,
    this.unitName,
    required this.officerId,
    required this.gender,
    required this.role,
    this.fcmToken,
    required this.password,
    this.canReview = false,
    required this.createdAt,
  });

  factory Officer.fromJson(Map<String, dynamic> json) => Officer(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    unitId: json['unit_id'],
    // Support joined response: clearance_units: { unit_name: ... }
    unitName: (json['clearance_units'] is Map<String, dynamic>)
        ? (json['clearance_units']['unit_name'] as String?)
        : (json['unit_name'] as String?),
    officerId: json['officer_id'],
    gender: GenderExtension.fromString(json['gender']),
    role: UserRoleExtension.fromString(json['role']),
    fcmToken: json['fcm_token'],
    password: json['password'],
    canReview: json['can_review'] ?? false,
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
    'unit_id': unitId,
    // Note: unit_name is derived via join; not persisted here
    'officer_id': officerId,
    'gender': gender.value,
    'role': role.value,
    'fcm_token': fcmToken,
    'password': password,
    'can_review': canReview,
    'created_at': createdAt.toIso8601String(),
  };
}
