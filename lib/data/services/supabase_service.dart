import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client;
  SupabaseService(this.client);

  Future<AuthResponse> login(String emailOrMatric, String password) {
    // for matric no, you can map it to email in your DB before calling
    return client.auth.signInWithPassword(
      email: emailOrMatric,
      password: password,
    );
  }

  Future<void> logout() => client.auth.signOut();

  User? get currentUser => client.auth.currentUser;
}
