import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/workflow_controller.dart';

class WorkflowView extends GetView<WorkflowController> {
  const WorkflowView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
                  Text("Clearance Units", style: AppFont.titleMedium),
                  const SizedBox(height: 12),
                  controller.units.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              "No clearance units available",
                              style: AppFont.bodyMedium,
                            ),
                          ),
                        )
                      : ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.units.length,
                          onReorder: controller.reorderUnits,
                          itemBuilder: (context, index) {
                            final unit = controller.units[index];
                            return KeyedSubtree(
                              key: ValueKey(unit["id"]),
                              child: _buildUnitItem(
                                key: ValueKey(unit['id']),
                                icon: controller.iconFromKey(unit["icon_key"]),
                                title: unit["title"],
                                enabled: unit["enabled"],
                                color: Colors.blue.withValues(alpha: 0.1),
                                onTap: () =>
                                    _showEditInstructionSheet(context, unit, scheme),
                                onToggle: (val) =>
                                    controller.toggleUnit(unit, val),
                                scheme: scheme,
                              ),
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
    required VoidCallback onTap,
    required ColorScheme scheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  backgroundColor: color,
                  child: Icon(icon, color: Colors.blue),
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
                  activeThumbColor: scheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditInstructionSheet(
    BuildContext context,
    Map<String, dynamic> unit,
    ColorScheme scheme,
  ) {
    final ctrl = Get.find<WorkflowController>();
    final formKey = GlobalKey<FormState>();
    final instructionCtrl = TextEditingController(
      text: unit["instructions"] ?? "",
    );

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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Edit Instructions", style: AppFont.titleMedium),
                  const SizedBox(height: 12),
                  Text(unit["title"], style: AppFont.bodyLarge),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: instructionCtrl,
                    maxLines: 6,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Enter instructions"
                        : null,
                    decoration: InputDecoration(
                      labelText: "Instructions / Guidelines",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ctrl.updateInstructions(
                            unit,
                            instructionCtrl.text.trim(),
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
