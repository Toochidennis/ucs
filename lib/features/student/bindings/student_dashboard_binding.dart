import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/clearance_controller.dart';
import 'package:ucs/features/student/controllers/student_dashboard_controller.dart';
import 'package:ucs/features/student/controllers/student_home_controller.dart';
import 'package:ucs/features/student/controllers/student_notification_controller.dart';
import 'package:ucs/features/student/controllers/student_profile_controller.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StudentDashboardController(), permanent: true);
    Get.lazyPut(() => StudentHomeController(), fenix: true);
    Get.lazyPut(() => ClearanceController(), fenix: true);
    Get.lazyPut(() => StudentProfileController(), fenix: true);
    Get.lazyPut(() => StudentNotificationController(), fenix: true);
  }
}
