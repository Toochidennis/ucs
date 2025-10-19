import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import '../controllers/student_profile_controller.dart';

class StudentProfileView extends GetView<StudentProfileController> {
  const StudentProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
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
                  Text("Profile", style: AppFont.titleSmall),
                  TextButton(
                    onPressed: () => controller.editProfile(),
                    child: Text("Edit", style: AppFont.titleMedium),
                  ),
                ],
              ),
            ),

            // Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      "SJ",
                      style: AppFont.titleLarge.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Sarah Johnson", style: AppFont.titleMedium),
                  const SizedBox(height: 4),
                  Text("Computer Science Student", style: AppFont.bodyMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text("Active", style: AppFont.bodySmall.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Personal Info
            _sectionCard(
              title: "Personal Information",
              children: [
                _infoRow("Matric Number", "CS/2020/001"),
                _infoRow("Email", "sarah.johnson@university.edu"),
                _infoRow("Phone", "+234 801 234 5678"),
                _infoRow("Department", "Computer Science"),
                _infoRow("Level", "400 Level"),
                _infoRow("Session", "2024/2025"),
              ],
            ),

            // Settings
            _sectionCard(
              title: "Settings",
              children: [
                _toggleRow("Push Notifications", true, Icons.notifications,
                    Colors.purple, (value) {
                  controller.togglePushNotifications(value);
                }),
                _toggleRow("Email Updates", true, Icons.mail, Colors.orange,
                    (value) {
                  controller.toggleEmailUpdates(value);
                }),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade600,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Sign Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Card Wrapper
  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppFont.titleSmall),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  /// Info Row
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppFont.bodySmall),
          Flexible(
            child: Text(
              value,
              style: AppFont.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// Toggle Row
  Widget _toggleRow(
    String label,
    bool value,
    IconData icon,
    Color color,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 18,
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Text(label,
                  style:
                      AppFont.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.green,
          )
        ],
      ),
    );
  }
}
