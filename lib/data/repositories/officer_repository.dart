import 'package:ucs/data/models/officer.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/services/supabase_service.dart';

class OfficerRepository {
  final _supabase = SupabaseService.client;

  Future<List<ClearanceUnit>> fetchUnits() async {
    final response = await _supabase
        .from('clearance_units')
        .select('id, unit_name, position')
        .order('position', ascending: true);

    return (response as List)
        .map((json) => ClearanceUnit.fromJson(json))
        .toList();
  }

  Future<void> insertOfficer(Officer officer) async {
    await _supabase.from('officers').insert(officer.toJson());
  }

  Future<bool> officerIdExists(String officerId) async {
    final res = await _supabase
        .from('officers')
        .select('id')
        .eq('officer_id', officerId)
        .limit(1);
    return res.isNotEmpty;
  }

  Future<List<Officer>> fetchAllOfficers() async {
    final response = await _supabase
        .from('officers')
        .select('*, clearance_units(unit_name)')
        .order('created_at', ascending: false);

    return (response as List).map((json) => Officer.fromJson(json)).toList();
  }

  Future<Officer?> fetchOfficerById(String id) async {
    final response = await _supabase
        .from('officers')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Officer.fromJson(response);
  }

  Future<void> updateOfficer(String id, Map<String, dynamic> updates) async {
    // Filter out null or empty values
    updates.removeWhere((key, value) => value == null || value == '');
    await _supabase.from('officers').update(updates).eq('id', id);
  }
}
