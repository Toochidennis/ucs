import 'package:ucs/data/models/enums.dart';

class ClearanceDocument {
  final String id;
  final String studentId;
  final String unitId;
  final String requirementId;
  final String fileUrl;
  final String? fileName;
  final String? fileType;
  final DateTime submittedAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final ClearanceStatusEnum status; // 'pending', 'approved', 'rejected'
  final String? remark;

  ClearanceDocument({
    required this.id,
    required this.studentId,
    required this.unitId,
    required this.requirementId,
    required this.fileUrl,
    this.fileName,
    this.fileType,
    required this.submittedAt,
    this.reviewedBy,
    this.reviewedAt,
    this.status = ClearanceStatusEnum.pending,
    this.remark,
  });

  factory ClearanceDocument.fromJson(Map<String, dynamic> json) =>
      ClearanceDocument(
        id: json['id'],
        studentId: json['student_id'],
        unitId: json['unit_id'],
        requirementId: json['requirement_id'],
        fileUrl: json['file_url'],
        fileName: json['file_name'],
        fileType: json['file_type'],
        submittedAt: DateTime.parse(json['submitted_at']),
        reviewedBy: json['reviewed_by'],
        reviewedAt: json['reviewed_at'] != null
            ? DateTime.parse(json['reviewed_at'])
            : null,
        status: ClearanceStatusEnumExtension.fromString(json['status']),
        remark: json['remark'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'unit_id': unitId,
    'requirement_id': requirementId,
    'file_url': fileUrl,
    'file_name': fileName,
    'file_type': fileType,
    'submitted_at': submittedAt.toIso8601String(),
    'reviewed_by': reviewedBy,
    'reviewed_at': reviewedAt?.toIso8601String(),
    'status': status.value,
    'remark': remark,
  };
}
