import 'package:ucs/data/models/enums.dart';

class Student {
  final String id;
  final String matricNo;
  final String password;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final DateTime? dob;
  final Gender gender;
  final String? major;
  final String faculty;
  final String department;
  final String level;
  final String? fcmToken;
  final StudentStatus status;
  final DateTime? createdAt;

  Student({
    required this.id,
    required this.matricNo,
    required this.password,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.dob,
    required this.gender,
    this.major,
    required this.faculty,
    required this.department,
    required this.level,
    this.fcmToken,
    required this.status,
    this.createdAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        matricNo: json['matric_no'],
        password: json['password'],
        firstName: json['first_name'],
        middleName: json['middle_name'],
        lastName: json['last_name'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
        gender: GenderExtension.fromString(json['gender']),
        major: json['major'],
        faculty: json['faculty'],
        department: json['department'],
        level: json['level'],
        fcmToken: json['fcm_token'],
        status: StudentStatusExtension.fromString(json['status']),
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'matric_no': matricNo,
        'password': password,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'dob': dob?.toIso8601String(),
        'gender': gender.value,
        'major': major,
        'faculty': faculty,
        'department': department,
        'level': level,
        'fcm_token': fcmToken,
        'status': status.value,
        'created_at': createdAt?.toIso8601String(),
      };
}
