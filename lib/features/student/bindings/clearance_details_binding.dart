import 'package:get/get.dart';
import 'package:ucs/features/student/controllers/clearance_details_controller.dart';

class ClearanceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClearanceDetailsController>(() => ClearanceDetailsController());
  }
}
