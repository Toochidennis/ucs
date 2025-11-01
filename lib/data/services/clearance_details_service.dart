import 'dart:typed_data';

import 'package:ucs/data/models/clearance_document.dart';
import 'package:ucs/data/models/clearance_requirement.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/repositories/clearance_details_repository.dart';

class ClearanceDetailsService {
  final ClearanceDetailsRepository _repo = ClearanceDetailsRepository();

  Future<ClearanceUnit> getUnitWithRequirements(String unitId) async {
    return await _repo.fetchUnitWithRequirements(unitId);
  }

  Future<List<ClearanceDocument>> getUnitDocuments(
    String studentId,
    String unitId,
  ) async {
    return await _repo.fetchUnitDocuments(studentId, unitId);
  }

  Future<ClearanceDocument> upsertRequirementDocument({
    required String studentId,
    required String unitId,
    required ClearanceRequirement requirement,
    required String fileName,
    required Uint8List bytes,
  }) async {
    return await _repo.uploadAndUpsertRequirementDocument(
      studentId: studentId,
      unitId: unitId,
      requirementId: requirement.id,
      fileName: fileName,
      bytes: bytes,
    );
  }
}
