/// ===============================
/// 🧠 Global Application Enums
/// For UNN e-Clearance System
/// ===============================
library;

/// 🔹 Gender Enum
enum Gender { male, female, other }

extension GenderExtension on Gender {
  String get value {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      case Gender.other:
        return 'other';
    }
  }

  static Gender fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.other;
    }
  }
}

/// 🔹 User Role Enum
enum UserRole { admin, officer, student }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.officer:
        return 'officer';
      case UserRole.student:
        return 'student';
    }
  }

  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'officer':
        return UserRole.officer;
      default:
        return UserRole.student;
    }
  }
}

/// 🔹 Clearance Status Enum
enum ClearanceStatusEnum { pending, approved, rejected, suspended, cleared }

extension ClearanceStatusEnumExtension on ClearanceStatusEnum {
  String get value {
    switch (this) {
      case ClearanceStatusEnum.pending:
        return 'pending';
      case ClearanceStatusEnum.approved:
        return 'approved';
      case ClearanceStatusEnum.rejected:
        return 'rejected';
      case ClearanceStatusEnum.suspended:
        return 'suspended';
      case ClearanceStatusEnum.cleared:
        return 'cleared';
    }
  }

  static ClearanceStatusEnum fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'approved':
        return ClearanceStatusEnum.approved;
      case 'rejected':
        return ClearanceStatusEnum.rejected;
      case 'suspended':
        return ClearanceStatusEnum.suspended;
      case 'cleared':
        return ClearanceStatusEnum.cleared;
      default:
        return ClearanceStatusEnum.pending;
    }
  }
}

/// 🔹 Student Status Enum
/// (Represents the overall clearance progress of a student)
enum StudentStatus { pending, inProgress, cleared, suspended }

extension StudentStatusExtension on StudentStatus {
  String get value {
    switch (this) {
      case StudentStatus.pending:
        return 'pending';
      case StudentStatus.inProgress:
        return 'in_progress';
      case StudentStatus.cleared:
        return 'cleared';
      case StudentStatus.suspended:
        return 'suspended';
    }
  }

  static StudentStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'in_progress':
        return StudentStatus.inProgress;
      case 'cleared':
        return StudentStatus.cleared;
      case 'suspended':
        return StudentStatus.suspended;
      default:
        return StudentStatus.pending;
    }
  }
}

/// 🔹 Notification Type Enum
enum NotificationType { student, officer, admin }

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.student:
        return 'student';
      case NotificationType.officer:
        return 'officer';
      case NotificationType.admin:
        return 'admin';
    }
  }

  static NotificationType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'officer':
        return NotificationType.officer;
      case 'admin':
        return NotificationType.admin;
      default:
        return NotificationType.student;
    }
  }
}
