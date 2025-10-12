import 'package:ucs/data/models/enums.dart';

class ClearanceStatus {
  final String id;
  final String studentId;
  final String unitId;
  final String approvedBy;
  final ClearanceStatusEnum status;
  final String? comment;
  final DateTime? approvedAt;

  ClearanceStatus({
    required this.id,
    required this.studentId,
    required this.unitId,
    required this.approvedBy,
    required this.status,
    this.comment,
    this.approvedAt,
  });

  factory ClearanceStatus.fromJson(Map<String, dynamic> json) =>
      ClearanceStatus(
        id: json['id'],
        studentId: json['student_id'],
        unitId: json['unit_id'],
        approvedBy: json['approved_by'],
        status: ClearanceStatusEnumExtension.fromString(json['status']),
        comment: json['comment'],
        approvedAt: json['approved_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'unit_id': unitId,
    'officer_id': approvedBy,
    'status': status.value,
    'comment': comment,
    'updated_at': approvedAt?.toIso8601String(),
  };
}
