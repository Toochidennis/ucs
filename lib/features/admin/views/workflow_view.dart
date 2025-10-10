import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/admin/widgets/toggle_tile.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/workflow_controller.dart';

class WorkflowView extends GetView<WorkflowController> {
  const WorkflowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(
        () => CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Clearance Units", style: AppFont.titleMedium),
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Add Unit"),
                        onPressed: () => _showAddUnitSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  controller.units.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text("No clearance units yet",
                                style: AppFont.bodyMedium),
                          ),
                        )
                      : ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.units.length,
                          onReorder: controller.reorderUnits,
                          itemBuilder: (context, index) {
                            final unit = controller.units[index];
                            return _buildUnitItem(
                              key: ValueKey(unit["id"]),
                              icon: unit["icon"],
                              title: unit["title"],
                              enabled: unit["enabled"],
                              color: unit["color"],
                              onToggle: (val) =>
                                  controller.toggleUnit(unit, val),
                            );
                          },
                        ),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitItem({
    required Key key,
    required IconData icon,
    required String title,
    required bool enabled,
    required Color color,
    required Function(bool) onToggle,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppFont.bodyMedium),
            ],
          ),
          Row(
            children: [
              Icon(Icons.drag_handle, color: Colors.grey[400]),
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

  void _showAddUnitSheet(BuildContext context) {
    final ctrl = Get.find<WorkflowController>();

    final formKey = GlobalKey<FormState>();
    final instructionCtrl = TextEditingController();
    final RxBool enabled = true.obs;
    final RxString selectedUnitType = "".obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Clearance Unit", style: AppFont.titleMedium),
                  const SizedBox(height: 16),

                  // 🔽 Select Unit Type
                  DropdownButtonFormField<String>(
                    value: selectedUnitType.value.isEmpty
                        ? null
                        : selectedUnitType.value,
                    items: ctrl.allUnitTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      selectedUnitType.value = val ?? "";
                      ctrl.setRequirementsForUnit(selectedUnitType.value);
                    },
                    decoration: InputDecoration(
                      labelText: "Select Unit Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Please select a unit" : null,
                  ),

                  const SizedBox(height: 16),
                  ToggleTile(
                    title: "Enable Unit",
                    subtitle: "Allow this clearance unit to be active",
                    value: enabled,
                  ),

                  const SizedBox(height: 12),

                  // 🧩 Suggested Requirements
                  Obx(() {
                    if (ctrl.suggestedRequirements.isEmpty) {
                      return const SizedBox();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Requirements",
                            style: AppFont.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ctrl.suggestedRequirements.map((req) {
                            final selected =
                                ctrl.selectedRequirements.contains(req);
                            return ChoiceChip(
                              label: Text(req),
                              selected: selected,
                              selectedColor: const Color(AppColor.primary)
                                  .withValues(alpha: 0.15),
                              onSelected: (_) => ctrl.toggleRequirement(req),
                              labelStyle: TextStyle(
                                color: selected
                                    ? const Color(AppColor.primary)
                                    : Colors.grey[800],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),

                  // 📝 Large Instruction Field
                  TextFormField(
                    controller: instructionCtrl,
                    maxLines: 6,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Please enter clearance instructions"
                        : null,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Instructions / Guidelines",
                      hintText:
                          "Enter detailed guidance for students taking this clearance...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Save Unit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppColor.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final icon = ctrl.getIconForUnit(selectedUnitType());
                          ctrl.addUnitFromForm(
                            selectedUnitType(),
                            enabled.value,
                            instructionCtrl.text,
                            icon,
                          );
                          Get.back();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
