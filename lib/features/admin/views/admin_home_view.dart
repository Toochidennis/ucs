import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import '../controllers/admin_controller.dart';

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
          // 📊 Overview Cards
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildOverviewCard("Total Students", "1,247", "+12%", Icons.person, Colors.blue, Colors.green),
              _buildOverviewCard("Completed", "892", "+8%", Icons.check_circle, Colors.green, Colors.green),
              _buildOverviewCard("Pending", "245", "-3%", Icons.access_time, Colors.amber, Colors.orange),
              _buildOverviewCard("Officers", "34", "+2%", Icons.group, Colors.purple, Colors.blue),
            ],
          ),

          const SizedBox(height: 20),

          // 📈 Clearance Progress
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Clearance Progress", style: AppFont.titleMedium),
                  const SizedBox(height: 12),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text("📊 Chart Placeholder")),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProgressStat("72%", "Completion Rate", Colors.blue),
                      _buildProgressStat("18%", "In Progress", Colors.amber),
                      _buildProgressStat("10%", "Delayed", Colors.red),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ⚡ Quick Actions
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quick Actions", style: AppFont.titleMedium),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildQuickAction(Icons.person, "Students", Colors.blue[50]!, Colors.blue),
                      _buildQuickAction(Icons.person, "Officers", Colors.green[50]!, Colors.green),
                      _buildQuickAction(Icons.schema, "Workflow", Colors.purple[50]!, Colors.purple),
                      _buildQuickAction(Icons.bar_chart, "Reports", Colors.orange[50]!, Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 📰 Recent Activity
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recent Activity", style: AppFont.titleMedium),
                  const SizedBox(height: 12),
                  _buildActivity(Icons.check, "Finance clearance approved for John Doe", "by Dr. Smith • 5 minutes ago", Colors.green),
                  _buildActivity(Icons.person_add, "New student registered: Emily Chen", "Matric: CS/2025/042 • 15 minutes ago", Colors.blue),
                  _buildActivity(Icons.warning, "Library system maintenance scheduled", "Tomorrow 2:00 AM - 4:00 AM", Colors.amber),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Overview Card
  Widget _buildOverviewCard(String title, String value, String trend, IconData icon, Color bgColor, Color trendColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: bgColor.withOpacity(0.2),
                  child: Icon(icon, color: bgColor),
                ),
                Text(trend, style: AppFont.bodySmall.copyWith(color: trendColor)),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: AppFont.titleMedium),
            Text(title, style: AppFont.bodySmall),
          ],
        ),
      ),
    );
  }

  // Progress stat
  Widget _buildProgressStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: AppFont.titleMedium.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppFont.bodySmall),
      ],
    );
  }

  // Quick Action Button
  Widget _buildQuickAction(IconData icon, String label, Color bgColor, Color iconColor) {
    return InkWell(
      onTap: () {
        // TODO: navigate to screen
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(label, style: AppFont.bodyMedium.copyWith(color: iconColor)),
          ],
        ),
      ),
    );
  }

  // Recent Activity Item
  Widget _buildActivity(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppFont.bodyMedium),
                Text(subtitle, style: AppFont.caption),
              ],
            ),
          )
        ],
      ),
    );
  }
}
