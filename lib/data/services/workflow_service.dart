import 'package:get/get.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/models/clearance_requirement.dart';
import 'package:ucs/data/repositories/workflow_repository.dart';

class WorkflowService {
  final _repo = WorkflowRepository();

  final units = <ClearanceUnit>[].obs;

  Future<void> loadUnits() async {
    final data = await _repo.fetchUnitsWithRequirements();
    units.assignAll(data);
  }

  Future<void> updateUnit(ClearanceUnit unit) async {
    await _repo.updateUnit(unit);
    final index = units.indexWhere((u) => u.id == unit.id);
    if (index != -1) {
      units[index] = unit;
      units.refresh();
    }
  }

  Future<void> updateRequirement(ClearanceRequirement req) async {
    await _repo.updateRequirement(req);
    for (var unit in units) {
      final idx = unit.requirements.indexWhere((r) => r.id == req.id);
      if (idx != -1) {
        unit.requirements[idx] = req;
        units.refresh();
        break;
      }
    }
  }

  Future<void> reorderUnits(List<ClearanceUnit> reordered) async {
    for (int i = 0; i < reordered.length; i++) {
      reordered[i] = ClearanceUnit(
        id: reordered[i].id,
        unitName: reordered[i].unitName,
        instructions: reordered[i].instructions,
        icon: reordered[i].icon,
        position: i + 1,
        createdAt: reordered[i].createdAt,
        requirements: reordered[i].requirements,
      );
    }
    units.assignAll(reordered);
    await _repo.reorderUnits(units);
  }

  Future<void> reorderRequirements(String unitId) async {
    final unit = units.firstWhereOrNull((u) => u.id == unitId);
    if (unit == null) return;

    for (int i = 0; i < unit.requirements.length; i++) {
      unit.requirements[i] = ClearanceRequirement(
        id: unit.requirements[i].id,
        unitId: unitId,
        title: unit.requirements[i].title,
        description: unit.requirements[i].description,
        isMandatory: unit.requirements[i].isMandatory,
        position: i + 1,
        createdAt: unit.requirements[i].createdAt,
      );
    }

    await _repo.reorderRequirements(unitId, unit.requirements);
  }
}
