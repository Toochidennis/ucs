import 'package:get/get.dart';

class StudentDashboardController extends GetxController {
  var currentTab = 0.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }
}
