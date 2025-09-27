import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/env.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Env>(Env(), permanent: true);
    Get.put<SupabaseClient>(Supabase.instance.client, permanent: true);
  }
}
