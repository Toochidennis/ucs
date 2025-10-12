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
}
