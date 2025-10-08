import 'package:get/get.dart';
import 'package:ucs/core/config/env.dart';
import 'package:ucs/data/services/appwrite_service.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Env>(Env(), permanent: true);
    AppWriteService.initialize();
  }
}
