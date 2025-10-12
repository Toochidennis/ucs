class Settings {
  final String id;
  final String schoolName;
  final String? logoUrl;
  final String? session;
  final String? semester;
  final bool autoApproveClearance;
  final DateTime? clearanceDeadline;
  final String? contactEmail;
  final String? contactPhone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Settings({
    required this.id,
    required this.schoolName,
    this.logoUrl,
    this.session,
    this.semester,
    this.autoApproveClearance = false,
    this.clearanceDeadline,
    this.contactEmail,
    this.contactPhone,
    required this.createdAt,
    this.updatedAt,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    id: json['id'],
    schoolName: json['school_name'],
    logoUrl: json['logo_url'],
    session: json['session'],
    semester: json['semester'],
    autoApproveClearance:
        json['auto_approve_clearance'] == true ||
        json['auto_approve_clearance'] == 1,
    clearanceDeadline: json['clearance_deadline'] != null
        ? DateTime.parse(json['clearance_deadline'])
        : null,
    contactEmail: json['contact_email'],
    contactPhone: json['contact_phone'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'school_name': schoolName,
    'logo_url': logoUrl,
    'session': session,
    'semester': semester,
    'auto_approve_clearance': autoApproveClearance,
    'clearance_deadline': clearanceDeadline?.toIso8601String().split('T').first,
    'contact_email': contactEmail,
    'contact_phone': contactPhone,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
