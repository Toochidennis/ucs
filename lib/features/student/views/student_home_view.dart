import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/core/constants/app_color.dart';
import '../controllers/student_controller.dart';

class StudentDashboardView extends GetView<StudentController> {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person_outline,
                        color: Colors.grey, size: 22),
                  ),
                  Text("Dashboard", style: AppFont.titleSmall),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.notifications_none,
                            color: Colors.grey, size: 22),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(AppColor.error),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "3",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Welcome Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, Sarah Johnson", style: AppFont.titleLarge),
                  const SizedBox(height: 4),
                  Text("Complete your clearance process",
                      style: AppFont.bodyMedium),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Progress Tracker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Clearance Progress", style: AppFont.titleSmall),
                      const SizedBox(height: 16),
                      _progressItem(
                        icon: Icons.check,
                        color: Colors.green,
                        title: "Finance Office",
                        subtitle: "Approved",
                        subtitleStyle: AppFont.success,
                      ),
                      _progressItem(
                        icon: Icons.access_time,
                        color: Colors.orange,
                        title: "Library",
                        subtitle: "Pending Review",
                        subtitleStyle: AppFont.warning,
                      ),
                      _progressItem(
                        icon: Icons.more_horiz,
                        color: Colors.grey,
                        title: "Alumni Office",
                        subtitle: "Not Started",
                        subtitleStyle: AppFont.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Continue Clearance Process"),
              ),
            ),

            const SizedBox(height: 20),

            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("3",
                                style: AppFont.titleMedium
                                    .copyWith(color: Colors.green)),
                            const SizedBox(height: 4),
                            Text("Units Cleared",
                                style: AppFont.bodySmall
                                    .copyWith(color: Colors.green.shade700)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("6",
                                style: AppFont.titleMedium
                                    .copyWith(color: Colors.orange)),
                            const SizedBox(height: 4),
                            Text("Pending Units",
                                style: AppFont.bodySmall
                                    .copyWith(color: Colors.orange.shade700)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Recent Activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recent Activity", style: AppFont.titleSmall),
                      const SizedBox(height: 16),
                      _activityItem("Finance clearance approved", "2 hours ago",
                          Colors.green),
                      _activityItem("Library documents submitted", "1 day ago",
                          Colors.blue),
                      _activityItem(
                          "Hostel clearance pending", "3 days ago", Colors.orange),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
            backgroundColor: color.withOpacity(0.1),
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
            decoration:
                BoxDecoration(color: dotColor, shape: BoxShape.circle),
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
          )
        ],
      ),
    );
  }
}
