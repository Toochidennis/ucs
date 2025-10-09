import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/add_student_controller.dart';

class AddStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddStudentController>(() => AddStudentController());
  }
}
