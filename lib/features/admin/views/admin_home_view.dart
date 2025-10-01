import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/core/constants/app_color.dart';

class AdminHomeView extends GetView<AdminController> {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Header
          Text("Welcome, Admin", style: AppFont.titleLarge),
          const SizedBox(height: 8),
          Text("Here’s an overview of the clearance system today:",
              style: AppFont.bodyMedium),

          const SizedBox(height: 20),

          // Stats Grid
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                title: "Cleared",
                value: controller.totalCleared.value.toString(),
                color: const Color(AppColor.success),
                icon: Icons.check_circle,
              ),
              _buildStatCard(
                title: "Pending",
                value: controller.totalPending.value.toString(),
                color: const Color(AppColor.warning),
                icon: Icons.hourglass_bottom,
              ),
              _buildStatCard(
                title: "Rejected",
                value: controller.totalRejected.value.toString(),
                color: const Color(AppColor.error),
                icon: Icons.cancel,
              ),
              _buildStatCard(
                title: "Total Students",
                value: "1250", // TODO: fetch from Supabase
                color: const Color(AppColor.primary),
                icon: Icons.school,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Recent Activities
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recent Activities", style: AppFont.titleMedium),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person_add, color: Colors.green),
                    title: const Text("New student account created"),
                    subtitle: Text("2 mins ago", style: AppFont.bodySmall),
                  ),
                  ListTile(
                    leading: const Icon(Icons.check, color: Colors.blue),
                    title: const Text("Clearance approved for CSC/2019/001"),
                    subtitle: Text("10 mins ago", style: AppFont.bodySmall),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cancel, color: Colors.red),
                    title: const Text("Clearance rejected for LAW/2020/014"),
                    subtitle: Text("1 hour ago", style: AppFont.bodySmall),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(value, style: AppFont.titleMedium.copyWith(color: color)),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: AppFont.bodySmall),
          ],
        ),
      ),
    );
  }
}
