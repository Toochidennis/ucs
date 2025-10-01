import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/core/constants/app_color.dart';

class StudentsView extends GetView<AdminController> {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: open add student form
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by name or matric number",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                // TODO: implement search logic
              },
            ),
          ),

          // 📋 Students List
          Expanded(
            child: Obx(() {
              final students = controller.students; // RxList in controller
              if (students.isEmpty) {
                return Center(
                  child: Text(
                    "No students found",
                    style: AppFont.bodyMedium,
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final student = students[index];
                  return _buildStudentCard(student['name']!, student['matricNo']!,
                      student['department']!);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(String name, String matricNo, String department) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(AppColor.primary),
          child: Text(
            name[0].toUpperCase(),
            style: AppFont.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
        title: Text(name, style: AppFont.bodyLarge),
        subtitle: Text("$matricNo • $department", style: AppFont.bodySmall),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == "view") {
              // TODO: View profile
            } else if (value == "reset") {
              // TODO: Reset password
            } else if (value == "delete") {
              // TODO: Delete student
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: "view", child: Text("View Profile")),
            const PopupMenuItem(value: "reset", child: Text("Reset Password")),
            const PopupMenuItem(value: "delete", child: Text("Delete")),
          ],
        ),
      ),
    );
  }
}
