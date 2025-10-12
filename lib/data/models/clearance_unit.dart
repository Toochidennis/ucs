class ClearanceUnit {
  final String id;
  final String unitName;
  final String instructions;
  final String? icon;
  final int position;
  final DateTime? createdAt;

  ClearanceUnit({
    required this.id,
    required this.unitName,
    required this.instructions,
    this.icon,
    required this.position,
    this.createdAt,
  });

  factory ClearanceUnit.fromJson(Map<String, dynamic> json) => ClearanceUnit(
    id: json['id'],
    unitName: json['unit_name'],
    instructions: json['instructions'],
    icon: json['icon'],
    position: json['position'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'unit_name': unitName,
    'instructions': instructions,
    'icon': icon,
    'position': position,
    'created_at': createdAt?.toIso8601String(),
  };
}
