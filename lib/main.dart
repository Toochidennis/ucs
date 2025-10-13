import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/app.dart';
import 'package:ucs/core/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  await GetStorage.init();
  GetStorage().erase();

  runApp(const AppRoot());
}
