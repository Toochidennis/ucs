import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/student.dart';
import 'package:ucs/data/services/student_service.dart';
import 'package:uuid/uuid.dart';

class AddStudentController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final dob = TextEditingController();
  final matricNo = TextEditingController();
  final faculty = "".obs;
  final department = "".obs;
  final level = "400L".obs;
  final password = TextEditingController();
  final gender = "Male".obs;
  final studentStatus = "Pending".obs;
  final showPassword = false.obs;

  final _uuid = const Uuid();

  // Faculties -> Departments
  final faculties = {
    "Agriculture": [
      "Agricultural Economics",
      "Soil Science",
      "Animal Science",
      "Food Science and Technology",
      "Nutrition and Dietetics",
    ],
    "Arts": [
      "Mass Communication",
      "Archaeology and Tourism",
      "History",
      "Fine and Applied Arts",
      "Music",
      "English and Literary Studies",
      "Linguistics",
    ],
    "Biological Sciences": [
      "Biochemistry",
      "Microbiology",
      "Plant Science and Biotechnology",
      "Zoology",
    ],
    "Business Administration": [
      "Accountancy",
      "Banking and Finance",
      "Management",
      "Marketing",
    ],
    "Education": [
      "Arts Education",
      "Science Education",
      "Adult Education",
      "Library Education",
      "Computer Education",
    ],
    "Engineering": [
      "Civil Engineering",
      "Electrical Engineering",
      "Mechanical Engineering",
    ],
    "Law": [
      "Commercial and Corporate Law",
      "Customary and Indigenous Law",
      "International and Corporate Law",
      "Public Law",
    ],
    "Physical Sciences": [
      "Computer Science",
      "Geology",
      "Physics and Astronomy",
      "Pure and Industrial Chemistry",
      "Mathematics",
      "Statistics",
    ],
    "Social Sciences": [
      "Economics",
      "Geography",
      "Political Science",
      "Psychology",
      "Public Administration",
      "Sociology and Anthropology",
      "Religion and Cultural Studies",
      "Social Work",
    ],
    "Veterinary Medicine": [
      "Veterinary Anatomy",
      "Animal Health and Production",
      "Veterinary Medicine",
      "Veterinary Obstetrics",
      "Veterinary Surgery and Radiology",
    ],
  };

  Map<String, List<String>> get departments => faculties;

  @override
  void onInit() {
    ever(faculty, (_) {
      department.value = "";
    });
    super.onInit();
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    final hashedPassword = BCrypt.hashpw(password.text, BCrypt.gensalt());

    final student = Student(
      id: _uuid.v4(),
      matricNo: matricNo.text,
      password: hashedPassword,
      firstName: firstName.text,
      middleName: middleName.text.isEmpty ? null : middleName.text,
      lastName: lastName.text,
      email: email.text.isEmpty ? null : email.text,
      phoneNumber: phone.text.isEmpty ? null : phone.text,
      dob: dob.text.isEmpty ? null : DateTime.tryParse(dob.text),
      gender: GenderExtension.fromString(gender.value),
      faculty: faculty.value,
      department: department.value,
      level: level.value,
      status: StudentStatusExtension.fromString(studentStatus.value),
      createdAt: DateTime.now(),
    );

    await StudentService().addStudent(student);
  }
}
