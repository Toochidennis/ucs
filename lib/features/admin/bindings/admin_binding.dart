import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/admin_controller.dart';
import 'package:ucs/features/admin/controllers/admin_settings_controller.dart';
import 'package:ucs/features/admin/controllers/workflow_controller.dart';
import 'package:ucs/features/admin/controllers/add_student_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put the AdminController when it's first used
    Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<WorkflowController>(() => WorkflowController());
    Get.lazyPut<AddStudentController>(() => AddStudentController());
    Get.lazyPut<AdminSettingsController>(() => AdminSettingsController());
  }
}
