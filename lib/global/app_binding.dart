import 'package:get/get.dart';
import 'package:ucs/features/auth/controllers/splash_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
