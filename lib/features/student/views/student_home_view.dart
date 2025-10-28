import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/student/controllers/student_home_controller.dart';

class StudentHomeView extends GetView<StudentHomeController> {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.progressList.isEmpty) {
          return Center(
            child: SpinKitChasingDots(
              color: theme.colorScheme.primary,
              size: 50,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Suspension Banner
                    Obx(() {
                      if (controller.isSuspended) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(
                              color: Colors.red.shade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: Colors.red.shade700,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account Suspended',
                                      style: AppFont.bodyLarge.copyWith(
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Your account has been suspended. You cannot start or continue clearance. Please contact the admin for assistance.',
                                      style: AppFont.bodySmall.copyWith(
                                        color: Colors.red.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // Welcome Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              "Welcome, ${controller.studentName.value}",
                              style: AppFont.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(
                            () => Text(
                              controller.welcomeMessage,
                              style: AppFont.bodyMedium.copyWith(
                                color: controller.isAllCompleted
                                    ? Colors.green
                                    : null,
                                fontWeight: controller.isAllCompleted
                                    ? FontWeight.w600
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Summary Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: Colors.green.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.clearedCount.value}",
                                        style: AppFont.titleMedium.copyWith(
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Units Cleared",
                                        style: AppFont.bodySmall.copyWith(
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                color: Colors.yellow.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.unclearedCount.value}",
                                        style: AppFont.titleMedium.copyWith(
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Pending Units",
                                        style: AppFont.bodySmall.copyWith(
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Progress Tracker
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Clearance Progress",
                                style: AppFont.titleSmall,
                              ),
                              const SizedBox(height: 16),
                              Obx(() {
                                if (controller.progressList.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'No clearance units available',
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: controller.progressList
                                      .map(
                                        (item) => _progressItem(
                                          icon: _getIconData(item['icon']),
                                          color: _getColor(item['color']),
                                          title: item['unitName'],
                                          subtitle: _getStatusText(
                                            item['status'],
                                          ),
                                          subtitleStyle: AppFont.bodySmall,
                                        ),
                                      )
                                      .toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Recent Activity
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Recent Activity",
                                style: AppFont.titleSmall,
                              ),
                              const SizedBox(height: 16),
                              Obx(() {
                                if (controller.recentActivities.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text('No recent activities'),
                                    ),
                                  );
                                }

                                return Column(
                                  children: controller.recentActivities
                                      .map(
                                        (activity) => _activityItem(
                                          activity['title'],
                                          activity['time'],
                                          _getColor(activity['color']),
                                        ),
                                      )
                                      .toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        // Hide button while loading or if no progress data
        if (controller.isLoading.value || controller.progressList.isEmpty) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: controller.isSuspended
              ? null
              : controller.onContinuePressed,
          icon: Icon(
            controller.isAllCompleted
                ? Icons.download_rounded
                : Icons.arrow_forward_rounded,
          ),
          label: Text(controller.buttonText),
          elevation: 4,
          backgroundColor: controller.isSuspended
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.primary,
          foregroundColor: controller.isSuspended
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onPrimary,
        );
      }),
    );
  }

  Widget _progressItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required TextStyle subtitleStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
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
                Text(title, style: AppFont.bodyLarge),
                Text(subtitle, style: subtitleStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem(String title, String time, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppFont.bodyMedium),
                const SizedBox(height: 2),
                Text(time, style: AppFont.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods to convert string values to Flutter types
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'check':
        return Icons.check;
      case 'access_time':
        return Icons.access_time;
      case 'close':
        return Icons.close;
      case 'more_horiz':
      default:
        return Icons.more_horiz;
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'grey':
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending Review';
      case 'not_started':
      default:
        return 'Not Started';
    }
  }
}
