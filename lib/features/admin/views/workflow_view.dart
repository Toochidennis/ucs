import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/workflow_controller.dart';

class WorkflowView extends GetView<WorkflowController> {
  const WorkflowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unit Items (reactive list)
                Column(
                  children: controller.units
                      .map(
                        (unit) => _buildUnitItem(
                          unit["icon"],
                          unit["title"],
                          unit["subtitle"],
                          unit["enabled"],
                          unit["color"],
                          (val) => controller.toggleUnit(unit, val),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Clearance Unit Item
  Widget _buildUnitItem(
    IconData icon,
    String title,
    String subtitle,
    bool enabled,
    Color color,
    Function(bool) onToggle,
  ) {
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
                backgroundColor: color.withValues(alpha: 0.2),
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
                activeThumbColor: const Color(AppColor.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
