import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/core/routes/app_routes.dart';

class AuthController extends GetxController {
  final Rx<Session?> session = Rx<Session?>(Supabase.instance.client.auth.currentSession);

  @override
  void onInit() {
    super.onInit();
  
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      session.value = event.session;
      _routeByRole();
    });
  }

  Future<void> loginWithEmail(String email, String password) async {
    await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  // For now we’ll route by a stored user role claim/column later.
  void _routeByRole() {
    if (session.value == null) {
      Get.offAllNamed(AppRoutes.studentDashboard);
      return;
    }
    // TODO: read role from profile (students/officers/admin)
    // Temporarily route student:
    Get.offAllNamed(AppRoutes.studentDashboard);
  }
}
