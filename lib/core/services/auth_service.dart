import 'package:bcrypt/bcrypt.dart';
import 'package:ucs/core/services/supabase_service.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/officer.dart';
import 'package:ucs/data/models/student.dart';

class AuthService {
  static Future<Login?> login({
    required String identifier,
    required String password,
  }) async {
    final officerMap = await SupabaseService.table('officers')
        .select()
        .or('email.eq.$identifier,officer_id.eq.$identifier')
        .limit(1)
        .maybeSingle();

    if (officerMap != null) {
      final officer = Officer.fromJson(officerMap);
      if (_checkPassword(password, officer.password)) {
        final userRole = officer.role == UserRole.admin
            ? UserRole.admin
            : UserRole.officer;
        return Login(
          userRole: userRole,
          raw: officerMap,
          id: officer.id,
          displayName: officer.name,
        );
      }
    }

    final studentMap = await SupabaseService.table('students')
        .select()
        .or('matric_no.eq.$identifier,email.eq.$identifier')
        .limit(1)
        .maybeSingle();

    if (studentMap != null) {
      final student = Student.fromJson(studentMap);
      final valid =
          _checkPassword(password, student.password) ||
          student.password == password;
      if (valid) {
        final fullName = _studentFullName(student);
        return Login(
          userRole: UserRole.student,
          raw: studentMap,
          id: student.id,
          displayName: fullName,
        );
      }
    }

    return null;
  }

  /// Logout (manual session cleanup)
  static Future<void> logout() async {
    // For manual login, clear local state or tokens here if you store any.
  }

  static bool _checkPassword(String plain, String? hash) {
    if (hash == null || hash.isEmpty) return false;
    try {
      return BCrypt.checkpw(plain, hash);
    } catch (_) {
      return false;
    }
  }

  static String _studentFullName(Student s) {
    final parts = [
      s.lastName,
      s.middleName ?? '',
      s.firstName,
    ].where((p) => p.isNotEmpty).join(' ');
    return parts.isNotEmpty ? parts : s.matricNo;
  }
}
