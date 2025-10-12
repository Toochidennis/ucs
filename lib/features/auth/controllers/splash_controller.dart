import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ucs/core/routes/app_routes.dart';
import 'package:ucs/data/models/login.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkUser();
  }

  Future<void> _checkUser() async {
    await Future.delayed(const Duration(seconds: 2));

    final box = GetStorage();
    final data = box.read('user');

    if (data != null) {
      final user = Login.fromJson(Map<String, dynamic>.from(data));

      if (user.isAdmin) {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else if (user.isOfficer) {
        Get.offAllNamed(AppRoutes.officerDashboard);
      } else {
        Get.offAllNamed(AppRoutes.studentDashboard);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
