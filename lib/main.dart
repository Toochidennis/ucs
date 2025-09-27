import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/app.dart';
import 'package:ucs/core/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final env = Env();

  await Supabase.initialize(
    url: env.supabaseUrl,
    anonKey: env.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(),
  );

  runApp(const AppRoot());
}
