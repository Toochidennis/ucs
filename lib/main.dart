import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/app.dart';
import 'package:ucs/data/services/firebase_service.dart';
import 'package:ucs/data/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  await SupabaseService.initialize();
  await GetStorage.init();
  //GetStorage().erase();

  runApp(const AppRoot());
}
