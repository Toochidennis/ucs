import 'package:ucs/data/models/settings.dart';
import 'package:ucs/data/repositories/settings_repository.dart';

class SettingsService {
  final _repo = SettingsRepository();

  Future<Settings?> getSettings() => _repo.fetchSettings();

  Future<Settings> saveSettings({
    Settings? existing,
    required String schoolName,
    String? session,
    String? semester,
    bool autoApproveClearance = false,
    DateTime? clearanceDeadline,
    String? contactEmail,
    String? contactPhone,
    String? logoUrl,
  }) async {
    final payload = <String, dynamic>{
      'school_name': schoolName,
      'session': session,
      'semester': semester,
      'auto_approve_clearance': autoApproveClearance,
      'clearance_deadline': clearanceDeadline
          ?.toIso8601String()
          .split('T')
          .first,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'logo_url': logoUrl,
    };

    if (existing == null) {
      return _repo.insertSettings(payload);
    } else {
      return _repo.updateSettings(existing.id, payload);
    }
  }
}
