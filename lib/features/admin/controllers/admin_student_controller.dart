import 'package:get/get.dart';

class AdminStudentController extends GetxController{
    final students = <Map<String, String>>[].obs;

    @override
  void onInit() {
    super.onInit();
        students.addAll([
      {
        "name": "John Doe",
        "matricNo": "CSC/2019/001",
        "department": "Computer Science",
      },
      {"name": "Jane Smith", "matricNo": "LAW/2020/014", "department": "Law"},
      {
        "name": "David Johnson",
        "matricNo": "ENG/2018/045",
        "department": "Engineering",
      },
    ]);
  }
}