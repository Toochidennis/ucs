import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/admin_dashboard_controller.dart';
import 'package:ucs/features/admin/controllers/admin_home_controller.dart';
import 'package:ucs/features/admin/controllers/admin_officer_controller.dart';
import 'package:ucs/features/admin/controllers/admin_settings_controller.dart';
import 'package:ucs/features/admin/controllers/admin_student_controller.dart';
import 'package:ucs/features/admin/controllers/workflow_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminDashboardController(), permanent: true);
    Get.lazyPut(() => AdminHomeController(), fenix: true);
    Get.lazyPut(() => WorkflowController(), fenix: true);
    Get.lazyPut(() => AdminSettingsController(), fenix: true);
    Get.lazyPut(() => AdminStudentController(), fenix: true);
    Get.lazyPut(() => AdminOfficerController(), fenix: true);
  }
}
