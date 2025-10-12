import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/core/config/env.dart';

class SupabaseService {
  static late final SupabaseClient client;

  static Future<void> initialize() async {
    final env = Env();

    await Supabase.initialize(
      url: env.supabaseUrl,
      anonKey: env.supabaseAnonKey,
    );

    client = Supabase.instance.client;
  }

  // Convenience getters
  static SupabaseClient get db => client;
  static SupabaseQueryBuilder table(String name) => client.from(name);
  static GoTrueClient get auth => client.auth;
  static SupabaseStorageClient get storage => client.storage;
}
