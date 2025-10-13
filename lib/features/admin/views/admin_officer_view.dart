import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_officer_controller.dart';

class AdminOfficersView extends GetView<AdminOfficerController> {
  const AdminOfficersView({super.key});

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
          // 🔍 Search Bar
          SliverToBoxAdapter(
            child: Padding(
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
          ),

          // 📋 Officers List
          Obx(() {
            final officers = controller.officers; // RxList from controller

            if (officers.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text("No officers found", style: AppFont.bodyMedium),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemCount: officers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final officer = officers[index];
                  return _buildOfficerCard(
                    officer['name']!,
                    officer['unit']!,
                    officer['email']!,
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

  Widget _buildOfficerCard(
    String name,
    String unit,
    String email,
    ColorScheme scheme,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primary,
          child: const Icon(Icons.person, color: Colors.white),
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
          itemBuilder: (context) => const [
            PopupMenuItem(value: "view", child: Text("View Details")),
            PopupMenuItem(value: "reset", child: Text("Reset Password")),
            PopupMenuItem(value: "remove", child: Text("Remove Officer")),
          ],
        ),
      ),
    );
  }
}
