import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/models/clearance_requirement.dart';
import 'package:ucs/data/services/supabase_service.dart';

class WorkflowRepository {
  final _supabase = SupabaseService.client;

  Future<List<ClearanceUnit>> fetchUnitsWithRequirements() async {
    final response = await _supabase
        .from('clearance_units')
        .select('*, clearance_requirements(*)')
        .order('position', ascending: true);

    return (response as List)
        .map((json) => ClearanceUnit.fromJson(json))
        .toList();
  }

  Future<void> updateUnit(ClearanceUnit unit) async {
    await _supabase.from('clearance_units').update({
      'unit_name': unit.unitName,
      'instructions': unit.instructions,
      'icon': unit.icon,
      'position': unit.position,
    }).eq('id', unit.id);
  }

  Future<void> updateRequirement(ClearanceRequirement req) async {
    await _supabase.from('clearance_requirements').update({
      'title': req.title,
      'description': req.description,
      'is_mandatory': req.isMandatory,
      'position': req.position,
    }).eq('id', req.id);
  }

  Future<void> reorderUnits(List<ClearanceUnit> units) async {
    final updates = units
        .map((u) => {'id': u.id, 'position': u.position})
        .toList();
    await _supabase.from('clearance_units').upsert(updates);
  }

  Future<void> reorderRequirements(
    String unitId,
    List<ClearanceRequirement> requirements,
  ) async {
    final updates = requirements
        .map((r) => {
              'id': r.id,
              'unit_id': unitId,
              'position': r.position,
            })
        .toList();
    await _supabase.from('clearance_requirements').upsert(updates);
  }
}
