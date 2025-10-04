import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/clearance_controller.dart';
import 'package:ucs/features/student/controllers/student_controller.dart';
import 'package:ucs/features/student/controllers/student_profile_controller.dart';
import 'package:ucs/shared/controllers/notifications_controller.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentController>(() => StudentController());
    Get.lazyPut<ClearanceController>(() => ClearanceController());
    Get.lazyPut<NotificationsController>(() => NotificationsController());
    Get.lazyPut<StudentProfileController>(() => StudentProfileController());
  }
}