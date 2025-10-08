import 'package:get/get.dart';
import 'package:appwrite/models.dart';
import 'package:ucs/core/routes/app_routes.dart';
import 'package:ucs/data/services/auth_service.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    try {
      final user = await authService.getCurrentUser();
      currentUser.value = user;

      print("output $authService");
      _routeByRole();
    } catch (_) {
      currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> login(String email, String password) async {
    await authService.login(email, password);
    await fetchCurrentUser();
  }

  Future<void> logout() async {
    await authService.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  void _routeByRole() {
    if (currentUser.value == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // Example routing logic
    final role = currentUser.value?.prefs.data['role'];
    switch (role) {
      case 'officer':
        Get.offAllNamed(AppRoutes.officerDashboard);
        break;
      case 'admin':
        Get.offAllNamed(AppRoutes.adminDashboard);
        break;
      default:
        Get.offAllNamed(AppRoutes.studentDashboard);
    }
  }
}
