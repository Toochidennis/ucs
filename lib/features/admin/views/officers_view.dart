import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/core/constants/app_color.dart';

class OfficersView extends GetView<AdminController> {
  const OfficersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Officers Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: open add officer form
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
                hintText: "Search by name or unit",
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

          // 📋 Officers List
          Expanded(
            child: Obx(() {
              final officers = controller.officers; // RxList in controller
              if (officers.isEmpty) {
                return Center(
                  child: Text(
                    "No officers found",
                    style: AppFont.bodyMedium,
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: officers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final officer = officers[index];
                  return _buildOfficerCard(
                    officer['name']!,
                    officer['unit']!,
                    officer['email']!,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficerCard(String name, String unit, String email) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(AppColor.secondary),
          child: Icon(Icons.person, color: const Color(AppColor.onSecondary)),
        ),
        title: Text(name, style: AppFont.bodyLarge),
        subtitle: Text("$unit • $email", style: AppFont.bodySmall),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == "view") {
              // TODO: View officer details
            } else if (value == "reset") {
              // TODO: Reset officer password
            } else if (value == "remove") {
              // TODO: Remove officer
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: "view", child: Text("View Details")),
            const PopupMenuItem(value: "reset", child: Text("Reset Password")),
            const PopupMenuItem(value: "remove", child: Text("Remove Officer")),
          ],
        ),
      ),
    );
  }
}
