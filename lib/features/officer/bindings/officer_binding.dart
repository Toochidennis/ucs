import 'package:get/get.dart';
import 'package:ucs/features/officer/controllers/officer_controller.dart';

class OfficerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficerController>(() => OfficerController());
  }
}
