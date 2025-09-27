import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/student_controller.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StudentController>(StudentController());
  }
}