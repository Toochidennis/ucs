import 'package:get/get.dart';

class StudentController extends GetxController {
  var currentTab = 0.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }
}
