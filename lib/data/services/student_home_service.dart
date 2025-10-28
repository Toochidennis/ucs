import 'package:ucs/data/models/clearance_unit.dart';
import 'package:ucs/data/repositories/student_home_repository.dart';

class StudentHomeService {
  final _repo = StudentHomeRepository();

  /// Fetch all clearance units
  Future<List<ClearanceUnit>> fetchClearanceUnits() async {
    return await _repo.fetchClearanceUnits();
  }

  /// Get the count of cleared units for a student
  Future<int> getClearedUnitsCount(String studentId) async {
    return await _repo.getClearedUnitsCount(studentId);
  }

  /// Get the count of uncleared (pending) units for a student
  Future<int> getUnclearedUnitsCount(String studentId) async {
    return await _repo.getUnclearedUnitsCount(studentId);
  }

  /// Get clearance progress for each unit
  /// Returns a list with unit details and their status
  Future<List<Map<String, dynamic>>> getClearanceProgress(
    String studentId,
  ) async {
    return await _repo.getClearanceProgress(studentId);
  }

  /// Get recent activities for a student
  /// Returns a list of recent document submissions and reviews
  Future<List<Map<String, dynamic>>> getRecentActivities(
    String studentId, {
    int limit = 5,
  }) async {
    return await _repo.getRecentActivities(studentId, limit: limit);
  }

  /// Get home data summary for a student
  /// Returns a map with all the data needed for the home view
  Future<Map<String, dynamic>> getHomeData(String studentId) async {
    try {
      final clearedCount = await getClearedUnitsCount(studentId);
      final unclearedCount = await getUnclearedUnitsCount(studentId);
      final progress = await getClearanceProgress(studentId);
      final activities = await getRecentActivities(studentId);

      return {
        'clearedCount': clearedCount,
        'unclearedCount': unclearedCount,
        'progress': progress,
        'activities': activities,
      };
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }

  /// Get student information from the server
  /// Returns student data including name and status
  Future<Map<String, dynamic>> getStudentInfo(String studentId) async {
    return await _repo.getStudentById(studentId);
  }
}
