import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import '../controllers/workflow_controller.dart';

class WorkflowView extends GetView<WorkflowController> {
  const WorkflowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text("Workflow Settings", style: AppFont.titleLarge),
              const SizedBox(height: 20),

              // Clearance Units Section
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Clearance Units", style: AppFont.titleMedium),
                          TextButton(
                            onPressed: controller.addUnit,
                            child: const Text("Add Unit"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Unit Items (reactive list)
                      Column(
                        children: controller.units
                            .map((unit) => _buildUnitItem(
                                  unit["icon"],
                                  unit["title"],
                                  unit["subtitle"],
                                  unit["enabled"],
                                  unit["color"],
                                  (val) => controller.toggleUnit(unit, val),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // System Settings Section
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("System Settings", style: AppFont.titleMedium),
                      const SizedBox(height: 12),

                      _buildSystemSetting(
                        "Auto-approve on document upload",
                        "Automatically approve when all documents are uploaded",
                        controller.autoApprove.value,
                        controller.toggleAutoApprove,
                      ),
                      _buildSystemSetting(
                        "Email notifications",
                        "Send email updates to students and officers",
                        controller.emailNotifications.value,
                        controller.toggleEmailNotifications,
                      ),
                      _buildSystemSetting(
                        "Deadline reminders",
                        "Send deadline reminders 7 days before",
                        controller.deadlineReminders.value,
                        controller.toggleDeadlineReminders,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // Clearance Unit Item
  Widget _buildUnitItem(IconData icon, String title, String subtitle,
      bool enabled, Color color, Function(bool) onToggle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left section
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppFont.bodyMedium),
                  Text(subtitle, style: AppFont.caption),
                ],
              ),
            ],
          ),

          // Right actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  // TODO: edit unit
                },
              ),
              Switch(
                value: enabled,
                onChanged: onToggle,
                activeColor: const Color(AppColor.primary),
              ),
            ],
          )
        ],
      ),
    );
  }

  // System Setting Item
  Widget _buildSystemSetting(
      String title, String subtitle, bool enabled, Function(bool) onToggle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Setting label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppFont.bodyMedium),
                Text(subtitle, style: AppFont.caption),
              ],
            ),
          ),
          // Toggle
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: const Color(AppColor.primary),
          ),
        ],
      ),
    );
  }
}
