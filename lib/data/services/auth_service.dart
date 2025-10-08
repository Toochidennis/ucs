import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' hide Log;
import 'package:intl/intl.dart';
import 'package:ucs/data/services/appwrite_service.dart';
import 'package:ucs/data/models/log.dart';

class AuthService {
  final Account account = AppWriteService.account;
  final Client client = AppWriteService.client;

  Future<Session> login(String email, String password) async {
    return await account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
  }

  Future<User> getCurrentUser() async {
    return await account.get();
  }

  Future<Log> ping() async {
    try {
      final response = await client.ping();

      return Log(
        date: _getCurrentDate(),
        status: 200,
        method: "GET",
        path: '/ping',
        response: response,
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "GET",
        path: '/ping',
        response: error.message ?? "Unknown error",
      );
    }
  }

  String _getCurrentDate() {
    return DateFormat("MMM dd, HH:mm").format(DateTime.now());
  }
}
