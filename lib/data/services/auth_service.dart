import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:ucs/data/services/appwrite_service.dart';

class AuthService {
  final Account account = AppWriteService.account;

  Future<Session> login(String email, String password) async {
    return await account.createEmailPasswordSession(email: email, password: password);
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
  }

  Future<User> getCurrentUser() async {
    return await account.get();
  }
}
