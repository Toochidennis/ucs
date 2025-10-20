import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/officer.dart';
import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/repositories/officer_repository.dart';

class OfficerService {
  final _repo = OfficerRepository();

  Future<List<ClearanceUnit>> fetchUnits() => _repo.fetchUnits();

  Future<void> saveOfficer({
    required String name,
    String? email,
    String? phone,
    required String officerId,
    required String password,
    required Gender gender,
    required UserRole role,
    required bool canReview,
    required String unitId,
  }) async {
    // Check duplicate ID
    final exists = await _repo.officerIdExists(officerId);
    if (exists) throw Exception("Officer ID already exists");

    final officer = Officer(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phoneNumber: phone,
      unitId: unitId,
      officerId: officerId,
      gender: gender,
      role: role,
      password: BCrypt.hashpw(password, BCrypt.gensalt()),
      canReview: canReview,
      createdAt: DateTime.now(),
    );

    await _repo.insertOfficer(officer);
  }
}
