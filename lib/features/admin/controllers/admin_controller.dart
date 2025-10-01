import 'package:get/get.dart';

class AdminController extends GetxController {
  // Observables
  final totalCleared = 0.obs;
  final totalPending = 0.obs;
  final totalRejected = 0.obs;
  final students = <Map<String, String>>[].obs;
  final officers = <Map<String, String>>[].obs;

  // Example: track current tab index
  final currentTab = 0.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }

  @override
  void onInit() {
    super.onInit();

 students.addAll([
    {"name": "John Doe", "matricNo": "CSC/2019/001", "department": "Computer Science"},
    {"name": "Jane Smith", "matricNo": "LAW/2020/014", "department": "Law"},
    {"name": "David Johnson", "matricNo": "ENG/2018/045", "department": "Engineering"},
  ]);

   officers.addAll([
    {"name": "Prof. Okafor", "unit": "Finance Office", "email": "okafor@unn.edu.ng"},
    {"name": "Mrs. Johnson", "unit": "Library", "email": "johnson@unn.edu.ng"},
    {"name": "Dr. Musa", "unit": "Student Affairs", "email": "musa@unn.edu.ng"},
  ]);
  }

}
