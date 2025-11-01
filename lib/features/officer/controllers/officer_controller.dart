import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfficerController extends GetxController {
  // Tabs
  var currentTab = 0.obs;
  var showDetail = false.obs;
  var headerTitle = "Dashboard".obs;

  // Comment box
  var showCommentBox = false.obs;
  final commentCtrl = TextEditingController();

  // Dummy students
  final pendingStudents = [
    {"matric": "STU001", "name": "Michael Johnson"},
    {"matric": "STU002", "name": "Sarah Williams"},
    {"matric": "STU003", "name": "David Chen"},
    {"matric": "STU004", "name": "Emily Rodriguez"},
    {"matric": "STU005", "name": "James Thompson"},
  ];

  final approvedStudents = [
    {"matric": "STU006", "name": "Lisa Anderson"},
    {"matric": "STU007", "name": "Robert Martinez"},
  ];

  final rejectedStudents = [
    {"matric": "STU008", "name": "Jennifer Davis"},
  ];

  // Dummy documents
  final documents = [
    {
      "title": "Academic Transcript",
      "image":
          "https://readdy.ai/api/search-image?query=academic%20transcript%20document...",
    },
    {
      "title": "Library Clearance",
      "image":
          "https://readdy.ai/api/search-image?query=library%20clearance%20certificate...",
    },
    {
      "title": "Student ID",
      "image":
          "https://readdy.ai/api/search-image?query=student%20ID%20card%20with%20photo...",
    },
    {
      "title": "Hostel Clearance",
      "image":
          "https://readdy.ai/api/search-image?query=hostel%20clearance%20certificate...",
    },
  ];

  List<Map<String, dynamic>> getStudentsForTab(int index) {
    switch (index) {
      case 1:
        return approvedStudents;
      case 2:
        return rejectedStudents;
      default:
        return pendingStudents;
    }
  }

  void changeTab(int index) => currentTab.value = index;

  void openStudentDetail(String name) {
    showDetail.value = true;
    headerTitle.value = name;
  }

  void backToDashboard() {
    showDetail.value = false;
    headerTitle.value = "Dashboard";
    showCommentBox.value = false;
    commentCtrl.clear();
  }

  void approveRequest() {
    Get.snackbar(
      "Approved",
      "Student request approved successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
    backToDashboard();
  }

  void rejectRequest() {
    if (!showCommentBox.value) {
      showCommentBox.value = true;
      return;
    }

    final comment = commentCtrl.text.trim();
    if (comment.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a rejection reason",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      "Rejected",
      "Request rejected: $comment",
      snackPosition: SnackPosition.BOTTOM,
    );
    backToDashboard();
  }
}
