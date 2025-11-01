import 'package:get/get.dart';
import 'package:ucs/features/officer/controllers/officer_dashboard_controller.dart';
import 'package:ucs/features/officer/controllers/officer_home_controller.dart';
import 'package:ucs/features/officer/controllers/officer_profile_controller.dart';
import 'package:ucs/shared/controllers/notifications_controller.dart';

class OfficerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OfficerDashboardController(), permanent: true);
    Get.lazyPut(() => OfficerHomeController(), fenix: true);
    Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut(() => OfficerProfileController(), fenix: true);
  }
}
