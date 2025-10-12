import 'package:ucs/core/services/auth_service.dart';
import 'package:ucs/data/models/login.dart';

class AuthRepository {
  Future<Login?> login(String identifier, String password) async {
    return await AuthService.login(identifier: identifier, password: password);
  }

  Future<void> logout() async => await AuthService.logout();
}
