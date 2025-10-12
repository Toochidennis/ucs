class ClearanceRequirement {
  final String id;
  final String unitId;
  final String title;
  final String? description;
  final bool isMandatory;
  final DateTime createdAt;

  ClearanceRequirement({
    required this.id,
    required this.unitId,
    required this.title,
    this.description,
    this.isMandatory = true,
    required this.createdAt,
  });

  factory ClearanceRequirement.fromJson(Map<String, dynamic> json) =>
      ClearanceRequirement(
        id: json['id'],
        unitId: json['unit_id'],
        title: json['title'],
        description: json['description'],
        isMandatory: json['is_mandatory'] ?? true,
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'unit_id': unitId,
        'title': title,
        'description': description,
        'is_mandatory': isMandatory,
        'created_at': createdAt.toIso8601String(),
      };
}
