import 'package:get/get.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/models/clearance_requirement.dart';
import 'package:ucs/data/services/workflow_service.dart';

class WorkflowController extends GetxController {
  final _service = WorkflowService();

  final units = <ClearanceUnit>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUnits();
  }

  Future<void> loadUnits() async {
    isLoading.value = true;
    try {
      await _service.loadUnits();
      units.assignAll(_service.units);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveUnit(ClearanceUnit updatedUnit) async {
    await _service.updateUnit(updatedUnit);
  }

  Future<void> saveRequirement(ClearanceRequirement updatedReq) async {
    await _service.updateRequirement(updatedReq);
  }

  void reorderUnits(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = units.removeAt(oldIndex);
    units.insert(newIndex, item);
    for (int i = 0; i < units.length; i++) {
      units[i] = ClearanceUnit(
        id: units[i].id,
        unitName: units[i].unitName,
        instructions: units[i].instructions,
        icon: units[i].icon,
        position: i + 1,
        createdAt: units[i].createdAt,
        requirements: units[i].requirements,
      );
    }
    _service.reorderUnits(units);
  }

  void reorderRequirements(ClearanceUnit unit, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final reqs = unit.requirements.toList();
    final item = reqs.removeAt(oldIndex);
    reqs.insert(newIndex, item);

    for (int i = 0; i < reqs.length; i++) {
      reqs[i] = ClearanceRequirement(
        id: reqs[i].id,
        unitId: reqs[i].unitId,
        title: reqs[i].title,
        description: reqs[i].description,
        isMandatory: reqs[i].isMandatory,
        position: i + 1,
        createdAt: reqs[i].createdAt,
      );
    }

    final index = units.indexWhere((u) => u.id == unit.id);
    if (index != -1) {
      units[index] = ClearanceUnit(
        id: unit.id,
        unitName: unit.unitName,
        instructions: unit.instructions,
        icon: unit.icon,
        position: unit.position,
        createdAt: unit.createdAt,
        requirements: reqs,
      );
      units.refresh();
    }
    _service.reorderRequirements(unit.id);
  }
}
