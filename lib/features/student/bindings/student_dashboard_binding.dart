import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/clearance_controller.dart';
import 'package:ucs/features/student/controllers/student_dashboard_controller.dart';
import 'package:ucs/features/student/controllers/student_profile_controller.dart';
import 'package:ucs/shared/controllers/notifications_controller.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StudentDashboardController(), permanent: true);
    Get.lazyPut<ClearanceController>(() => ClearanceController(), fenix: true);
    Get.lazyPut<NotificationsController>(() => NotificationsController(), fenix: true);
    Get.lazyPut<StudentProfileController>(() => StudentProfileController(), fenix: true);
  }
}