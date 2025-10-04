import 'package:get/get.dart';

class OfficerController extends GetxController {
  final currentTab = 0.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }
}
