import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/data/models/clearance_document.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/services/supabase_service.dart';

class ClearanceDetailsRepository {
  final SupabaseClient _client = SupabaseService.db;

  Future<ClearanceUnit> fetchUnitWithRequirements(String unitId) async {
    final res = await _client
        .from('clearance_units')
        .select('*, clearance_requirements(*)')
        .eq('id', unitId)
        .single();
    return ClearanceUnit.fromJson(res);
  }

  Future<List<ClearanceDocument>> fetchUnitDocuments(
    String studentId,
    String unitId,
  ) async {
    final res = await _client
        .from('clearance_documents')
        .select('*')
        .eq('student_id', studentId)
        .eq('unit_id', unitId)
        .order('submitted_at', ascending: false);
    return (res as List).map((e) => ClearanceDocument.fromJson(e)).toList();
  }

  Future<ClearanceDocument> uploadAndUpsertRequirementDocument({
    required String studentId,
    required String unitId,
    required String requirementId,
    required String fileName,
    required Uint8List bytes,
    String bucket = 'clearance-documents',
  }) async {
    // Upload to storage
    final path =
        '$studentId/$unitId/$requirementId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await SupabaseService.storage
        .from(bucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
    final publicUrl = SupabaseService.storage.from(bucket).getPublicUrl(path);

    // Insert new document row (allow multiple submissions per requirement)
    final payload = {
      'student_id': studentId,
      'unit_id': unitId,
      'requirement_id': requirementId,
      'file_url': publicUrl,
      'file_name': fileName,
      'file_type': _inferMime(fileName),
      'submitted_at': DateTime.now().toIso8601String(),
      'status': ClearanceStatusEnum.pending.value,
      'remark': null,
    };

    final res = await _client
        .from('clearance_documents')
        .insert(payload)
        .select()
        .single();
    return ClearanceDocument.fromJson(res);
  }

  String _inferMime(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }
}
