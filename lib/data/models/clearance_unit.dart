import 'package:ucs/data/models/clearance_requirement.dart';

class ClearanceUnit {
  final String id;
  final String unitName;
  final String instructions;
  final String? icon;
  final int position;
  final DateTime? createdAt;
  final List<ClearanceRequirement> requirements;

  ClearanceUnit({
    required this.id,
    required this.unitName,
    required this.instructions,
    this.icon,
    required this.position,
    this.createdAt,
    this.requirements = const [],
  });

  factory ClearanceUnit.fromJson(Map<String, dynamic> json) {
    final reqs = json['clearance_requirements'];
    return ClearanceUnit(
      id: json['id'],
      unitName: json['unit_name'],
      instructions: json['instructions'],
      icon: json['icon'],
      position: json['position'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      requirements: reqs != null
          ? List<ClearanceRequirement>.from(
              (reqs as List).map((r) => ClearanceRequirement.fromJson(r)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'unit_name': unitName,
    'instructions': instructions,
    'icon': icon,
    'position': position,
    'created_at': createdAt?.toIso8601String(),
    // ✅ Nested serialization (for upserts if needed)
    if (requirements.isNotEmpty)
      'clearance_requirements': requirements.map((r) => r.toJson()).toList(),
  };
}
