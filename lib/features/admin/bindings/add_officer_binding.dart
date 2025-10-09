import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/add_officer_controller.dart';

class AddOfficerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddOfficerController>(() => AddOfficerController());
  }
}
