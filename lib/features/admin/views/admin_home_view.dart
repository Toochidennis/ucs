import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_dashboard_controller.dart';
import 'package:ucs/features/admin/controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await controller.loadDashboard();
          await controller.loadRecentActivities();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            Obx(() {
              if (controller.isLoading.value) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SpinKitChasingDots(color: scheme.primary, size: 48),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Obx(
                      () => GridView.count(
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
                            value: controller.totalStudents.value.toString(),
                            color: scheme.primary,
                            containerColor: scheme.primaryContainer,
                            onContainerColor: scheme.onPrimaryContainer,
                            trend: controller.studentsTrendUp.value ? "↑" : "↓",
                          ),
                          _buildCompactStat(
                            icon: Icons.check_circle,
                            title: "Completed",
                            value: controller.totalCleared.value.toString(),
                            color: scheme.secondary,
                            containerColor: scheme.secondaryContainer,
                            onContainerColor: scheme.onSecondaryContainer,
                            trend: controller.clearedTrendUp.value ? "↑" : "↓",
                          ),
                          _buildCompactStat(
                            icon: Icons.access_time,
                            title: "Pending",
                            value: controller.totalPending.value.toString(),
                            color: scheme.tertiary,
                            containerColor: scheme.tertiaryContainer,
                            onContainerColor: scheme.onTertiaryContainer,
                            trend: controller.pendingTrendUp.value ? "↑" : "↓",
                          ),
                          _buildCompactStat(
                            icon: Icons.group,
                            title: "Officers",
                            value: controller.totalOfficers.value.toString(),
                            color: scheme.primary,
                            containerColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            onContainerColor: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                            trend: controller.officersTrendUp.value ? "↑" : "↓",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

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
                              color: scheme.primary,
                              onTap: () => Get.find<AdminDashboardController>()
                                  .changeTab(1),
                            ),
                            _buildQuickActionList(
                              icon: Icons.people_alt_rounded,
                              title: "Manage Officers",
                              subtitle: "Add or update clearance officers",
                              color: scheme.secondary,
                              onTap: () => Get.find<AdminDashboardController>()
                                  .changeTab(2),
                            ),
                            _buildQuickActionList(
                              icon: Icons.timeline,
                              title: "Workflow Setup",
                              subtitle:
                                  "Define clearance sequence and permissions",
                              color: scheme.tertiary,
                              onTap: () => Get.find<AdminDashboardController>()
                                  .changeTab(3),
                            ),
                            _buildQuickActionList(
                              icon: Icons.settings_suggest,
                              title: "System Settings",
                              subtitle: "Configure clearance process and roles",
                              color: scheme.primary,
                              onTap: () => Get.find<AdminDashboardController>()
                                  .changeTab(4),
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
                            Obx(() {
                              if (controller.isLoadingActivities.value) {
                                return Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Center(
                                    child: SpinKitChasingDots(
                                      color: scheme.primary,
                                      size: 48,
                                    ),
                                  ),
                                );
                              }
                              final items = controller.recentActivities;
                              if (items.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Text(
                                    "No recent activity",
                                    style: AppFont.caption,
                                  ),
                                );
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 20),
                                itemBuilder: (context, index) {
                                  final e = items[index];
                                  final type = (e['type'] ?? '').toString();
                                  final status = (e['status'] ?? '').toString();
                                  final title = (e['title'] ?? '').toString();
                                  final by = (e['by'] ?? '').toString();
                                  final when = e['time'] is DateTime
                                      ? _timeAgo(e['time'] as DateTime)
                                      : '';

                                  IconData icon;
                                  Color color;
                                  if (type == 'submission') {
                                    icon = Icons.upload_rounded;
                                    color = scheme.primary;
                                  } else if (type == 'review' &&
                                      status == 'approved') {
                                    icon = Icons.check;
                                    color = Colors.green;
                                  } else if (type == 'review' &&
                                      status == 'rejected') {
                                    icon = Icons.close;
                                    color = Colors.red;
                                  } else {
                                    icon = Icons.rate_review;
                                    color = scheme.tertiary;
                                  }

                                  final studentName = (e['studentName'] ?? '')
                                      .toString();
                                  final activityTitle = studentName.isNotEmpty
                                      ? "$title for $studentName"
                                      : title;
                                  final subtitle = by.isNotEmpty
                                      ? "by $by • $when"
                                      : when;

                                  return _buildActivityItem(
                                    icon: icon,
                                    color: color,
                                    title: activityTitle,
                                    subtitle: subtitle,
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            }),
          ],
        ),
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
    Color? containerColor,
    Color? onContainerColor,
  }) {
    final scheme = Theme.of(Get.context!).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: containerColor ?? scheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: (onContainerColor ?? color).withOpacity(0.14),
            child: Icon(icon, color: onContainerColor ?? color),
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
                        color: onContainerColor ?? scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: AppFont.caption.copyWith(
                        color: (onContainerColor ?? scheme.onSurface)
                            .withOpacity(0.9),
                      ),
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
                      color: onContainerColor ?? color,
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
        backgroundColor: color.withOpacity(0.12),
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
          backgroundColor: color.withOpacity(0.12),
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

  String _timeAgo(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 45) return 'just now';
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    return '${diff.inDays}d ago';
  }
}
