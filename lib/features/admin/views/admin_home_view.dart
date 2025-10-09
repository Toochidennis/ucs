import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_dashboard_controller.dart';
import 'package:ucs/features/admin/controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- Grid of Compact Stats ---
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: [
                    _buildCompactStat(
                      icon: Icons.person,
                      title: "Students",
                      value: "1,247",
                      color: Colors.blue,
                      trend: "+12%",
                    ),
                    _buildCompactStat(
                      icon: Icons.check_circle,
                      title: "Completed",
                      value: "892",
                      color: Colors.green,
                      trend: "+8%",
                    ),
                    _buildCompactStat(
                      icon: Icons.access_time,
                      title: "Pending",
                      value: "245",
                      color: Colors.orange,
                      trend: "-3%",
                    ),
                    _buildCompactStat(
                      icon: Icons.group,
                      title: "Officers",
                      value: "34",
                      color: Colors.purple,
                      trend: "+2%",
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- Quick Actions Card ---
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Quick Actions", style: AppFont.titleMedium),
                        const SizedBox(height: 12),
                        _buildQuickActionList(
                          icon: Icons.person_add,
                          title: "Manage Students",
                          subtitle: "Add, edit or view student profiles",
                          color: Colors.blue,
                          onTap: () =>
                              Get.find<AdminDashboardController>().changeTab(1),
                        ),
                        _buildQuickActionList(
                          icon: Icons.people_alt_rounded,
                          title: "Manage Officers",
                          subtitle: "Add or update clearance officers",
                          color: Colors.green,
                          onTap: () =>
                              Get.find<AdminDashboardController>().changeTab(2),
                        ),
                        _buildQuickActionList(
                          icon: Icons.timeline,
                          title: "Workflow Setup",
                          subtitle: "Define clearance sequence and permissions",
                          color: Colors.purple,
                          onTap: () =>
                              Get.find<AdminDashboardController>().changeTab(3),
                        ),
                        _buildQuickActionList(
                          icon: Icons.settings_suggest,
                          title: "System Settings",
                          subtitle: "Configure clearance process and roles",
                          color: Colors.orange,
                          onTap: () =>
                              Get.find<AdminDashboardController>().changeTab(4),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- Recent Activity Card ---
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Recent Activity", style: AppFont.titleMedium),
                        const SizedBox(height: 12),
                        _buildActivityItem(
                          icon: Icons.check,
                          color: Colors.green,
                          title: "Finance clearance approved for John Doe",
                          subtitle: "by Dr. Smith • 5 minutes ago",
                        ),
                        const Divider(height: 20),
                        _buildActivityItem(
                          icon: Icons.person_add_alt_1,
                          color: Colors.blue,
                          title: "New student registered: Emily Chen",
                          subtitle: "Matric: CS/2025/042 • 15 minutes ago",
                        ),
                        const Divider(height: 20),
                        _buildActivityItem(
                          icon: Icons.warning_amber_rounded,
                          color: Colors.amber,
                          title: "Library system maintenance scheduled",
                          subtitle: "Tomorrow 2:00 AM - 4:00 AM",
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // --- Compact Stat Card ---
  Widget _buildCompactStat({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String trend,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: AppFont.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: AppFont.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Text(
                    trend,
                    style: AppFont.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionList({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: AppFont.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle, style: AppFont.caption),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFont.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(subtitle, style: AppFont.caption),
            ],
          ),
        ),
      ],
    );
  }
}
