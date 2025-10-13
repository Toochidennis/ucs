import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_student_controller.dart';

class AdminStudentsView extends GetView<AdminStudentController> {
  const AdminStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
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
          ),

          // --- Student List ---
          Obx(() {
            final students = controller.students;

            if (students.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text("No students found", style: AppFont.bodyMedium),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemCount: students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final student = students[index];
                  return _buildStudentCard(
                    student['name']!,
                    student['matricNo']!,
                    student['department']!,
                    scheme,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
    String name,
    String matricNo,
    String department,
    ColorScheme scheme,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primary,
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
          itemBuilder: (context) => const [
            PopupMenuItem(value: "view", child: Text("View Profile")),
            PopupMenuItem(value: "reset", child: Text("Reset Password")),
            PopupMenuItem(value: "delete", child: Text("Delete")),
          ],
        ),
      ),
    );
  }
}
