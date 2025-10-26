import 'package:ucs/data/models/settings.dart';
import 'package:ucs/data/services/supabase_service.dart';

class SettingsRepository {
  final String _table = 'settings';

  Future<Settings?> fetchSettings() async {
    final map = await SupabaseService.table(_table).select().limit(1).single();
    if (map.isNotEmpty) {
      return Settings.fromJson(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<Settings> insertSettings(Map<String, dynamic> data) async {
    final res = await SupabaseService.table(
      _table,
    ).insert(data).select().single();
    return Settings.fromJson(Map<String, dynamic>.from(res));
  }

  Future<Settings> updateSettings(
    String id,
    Map<String, dynamic> updates,
  ) async {
    updates.removeWhere((k, v) => v == null);
    final res = await SupabaseService.table(
      _table,
    ).update(updates).eq('id', id).select().single();
    return Settings.fromJson(Map<String, dynamic>.from(res));
  }
}
