import 'package:get/get.dart';
import 'package:ucs/features/auth/controllers/splash_controller.dart';
import 'package:ucs/features/auth/controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is always available across the app lifecycle
    Get.put(AuthController(), permanent: true);
    Get.put(SplashController());
  }
}
