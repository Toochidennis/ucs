import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/workflow_controller.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/models/clearance_requirement.dart';

class WorkflowView extends GetView<WorkflowController> {
  const WorkflowView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.units.isEmpty) {
          return const Center(child: Text('No clearance units found'));
        }

        return ReorderableListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.units.length,
          onReorder: controller.reorderUnits,
          itemBuilder: (context, index) {
            final unit = controller.units[index];
            return _buildUnitCard(
              context,
              unit,
              scheme,
              key: ValueKey(unit.id),
            );
          },
        );
      }),
    );
  }

  Widget _buildUnitCard(
    BuildContext context,
    ClearanceUnit unit,
    ColorScheme scheme, {
    required Key key,
  }) {
    final ctrl = Get.find<WorkflowController>();

    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.layers),
        title: Text(unit.unitName, style: AppFont.bodyLarge),
        subtitle: Text(
          "Position: ${unit.position}",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Instructions", style: AppFont.bodyMedium),
                const SizedBox(height: 6),
                TextFormField(
                  initialValue: unit.instructions,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Edit instructions",
                  ),
                  onFieldSubmitted: (val) {
                    final updated = ClearanceUnit(
                      id: unit.id,
                      unitName: unit.unitName,
                      instructions: val.trim(),
                      icon: unit.icon,
                      position: unit.position,
                      createdAt: unit.createdAt,
                      requirements: unit.requirements,
                    );
                    ctrl.saveUnit(updated);
                  },
                ),
                const SizedBox(height: 20),
                Text("Requirements", style: AppFont.bodyMedium),
                const SizedBox(height: 8),
                ReorderableListView(
                  key: ValueKey('req-${unit.id}'),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: (oldIndex, newIndex) =>
                      ctrl.reorderRequirements(unit, oldIndex, newIndex),
                  children: [
                    for (final req in unit.requirements)
                      _buildRequirementTile(
                        context,
                        req,
                        scheme,
                        key: ValueKey(req.id),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementTile(
    BuildContext context,
    ClearanceRequirement req,
    ColorScheme scheme, {
    required Key key,
  }) {
    final ctrl = Get.find<WorkflowController>();
    final titleCtrl = TextEditingController(text: req.title);
    final descCtrl = TextEditingController(text: req.description ?? "");

    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: "Requirement Title",
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (val) {
                final updated = ClearanceRequirement(
                  id: req.id,
                  unitId: req.unitId,
                  title: val.trim(),
                  description: req.description,
                  isMandatory: req.isMandatory,
                  position: req.position,
                  createdAt: req.createdAt,
                );
                ctrl.saveRequirement(updated);
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description (optional)",
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (val) {
                final updated = ClearanceRequirement(
                  id: req.id,
                  unitId: req.unitId,
                  title: req.title,
                  description: val.trim().isEmpty ? null : val.trim(),
                  isMandatory: req.isMandatory,
                  position: req.position,
                  createdAt: req.createdAt,
                );
                ctrl.saveRequirement(updated);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: req.isMandatory,
                      onChanged: (v) {
                        final updated = ClearanceRequirement(
                          id: req.id,
                          unitId: req.unitId,
                          title: req.title,
                          description: req.description,
                          isMandatory: v ?? true,
                          position: req.position,
                          createdAt: req.createdAt,
                        );
                        ctrl.updateRequirementInstantly(updated);
                        ctrl.saveRequirement(updated);
                      },
                    ),
                    const Text("Mandatory"),
                  ],
                ),
                const Icon(Icons.drag_handle, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
