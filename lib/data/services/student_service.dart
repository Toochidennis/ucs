import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/student.dart';
import 'package:ucs/data/repositories/student_repository.dart';

class StudentService {
  final _repo = StudentRepository();

  Future<void> addStudent(Student student) async {
    final context = Get.overlayContext;
    if (context == null) return;

    // Loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: SpinKitChasingDots(color: AppColor.lightPrimary, size: 48),
      ),
    );

    try {
      // Prevent duplicate matric number
      final exists = await _repo.studentExists(student.matricNo);
      if (exists) {
        Get.back(); // close loader
        Get.snackbar(
          'Duplicate Record',
          'A student with this matric number already exists.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _repo.addStudent(student);

      Get.back(); // close loader
      Get.snackbar(
        'Success',
        'Student added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back(); // close loader
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<List<Student>> getStudents() async {
    return await _repo.getStudents();
  }

  Future<void> resetStudentPassword(String id, String newPassword) async {
    final hash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    await _repo.updateStudent(id, {'password': hash});
  }

  Future<void> removeStudent(String id) async {
    await _repo.deleteStudent(id);
  }

  Future<void> updateStudentStatus(String id, StudentStatus status) async {
    await _repo.updateStudent(id, {'status': status.value});
  }
}
