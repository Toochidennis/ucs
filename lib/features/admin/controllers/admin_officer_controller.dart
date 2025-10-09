import 'package:get/get.dart';

class AdminOfficerController extends GetxController {
  final officers = <Map<String, String>>[].obs;

   @override
  void onInit() {
    super.onInit();



    officers.addAll([
      {
        "name": "Prof. Okafor",
        "unit": "Finance Office",
        "email": "okafor@unn.edu.ng",
      },
      {
        "name": "Mrs. Johnson",
        "unit": "Library",
        "email": "johnson@unn.edu.ng",
      },
      {
        "name": "Dr. Musa",
        "unit": "Student Affairs",
        "email": "musa@unn.edu.ng",
      },
    ]);
  }
}