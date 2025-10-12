import 'package:ucs/data/models/enums.dart';

class Login {
  final UserRole userRole;
  final Map<String, dynamic> raw;
  final String id;
  final String displayName;

  const Login({
    required this.userRole,
    required this.raw,
    required this.id,
    required this.displayName,
  });

  bool get isOfficer => userRole == UserRole.officer;
  bool get isStudent => userRole == UserRole.student;
  bool get isAdmin => userRole == UserRole.admin;

  Map<String, dynamic> toJson() {
    return {
      'userRole': userRole.name,
      'raw': raw,
      'id': id,
      'displayName': displayName,
    };
  }

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      userRole: UserRole.values.firstWhere(
        (e) => e.name == json['userRole'],
        orElse: () => UserRole.student,
      ),
      raw: Map<String, dynamic>.from(json['raw'] ?? {}),
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
    );
  }
}
