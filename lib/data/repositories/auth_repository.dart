import 'package:bcrypt/bcrypt.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/login.dart';
import 'package:ucs/data/models/officer.dart';
import 'package:ucs/data/models/student.dart';
import 'package:ucs/data/services/supabase_service.dart';

class AuthRepository {
  Future<Login?> login({
    required String identifier,
    required String password,
  }) async {
    // Try officer login first
    final officerMap = await SupabaseService.table('officers')
        .select()
        .or('email.eq."$identifier",officer_id.eq."$identifier"')
        .limit(1)
        .single();

    if (officerMap.isNotEmpty) {
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

    // Try student login
    final studentMap = await SupabaseService.table('students')
        .select()
        .or('matric_no.eq.$identifier,email.eq.$identifier')
        .limit(1)
        .single();

    if (studentMap.isNotEmpty) {
      final student = Student.fromJson(studentMap);
      final valid =
          _checkPassword(password, student.password) ||
          student.password == password;
      if (valid) {
        return Login(
          userRole: UserRole.student,
          raw: studentMap,
          id: student.id,
          displayName: _studentFullName(student),
        );
      }
    }

    return null;
  }

  Future<void> logout() async {
    // Just a stub — actual cleanup happens in AuthService
  }

  bool _checkPassword(String plain, String? hash) {
    if (hash == null || hash.isEmpty) return false;
    try {
      return BCrypt.checkpw(plain, hash);
    } catch (_) {
      return false;
    }
  }

  String _studentFullName(Student s) {
    final parts = [
      s.lastName,
      s.middleName ?? '',
      s.firstName,
    ].where((p) => p.isNotEmpty).join(' ');
    return parts.isNotEmpty ? parts : s.matricNo;
  }
}
