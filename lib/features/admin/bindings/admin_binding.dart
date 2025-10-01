import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put the AdminController when it's first used
     Get.lazyPut<AdminController>(() => AdminController());
  }
}