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
    final counts = await _repo.getClearanceCounts(studentId);
    return counts['cleared']!;
  }

  /// Get the count of uncleared (pending) units for a student
  Future<int> getUnclearedUnitsCount(String studentId) async {
    final counts = await _repo.getClearanceCounts(studentId);
    return counts['uncleared']!;
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

  /// Get home data summary for a student - OPTIMIZED VERSION
  /// Returns a map with all the data needed for the home view
  /// Uses parallel queries for better performance
  Future<Map<String, dynamic>> getHomeData(String studentId) async {
    try {
      // Execute all queries in PARALLEL for much faster loading
      final results = await Future.wait([
        _repo.getClearanceCounts(studentId),
        _repo.getClearanceProgress(studentId),
        _repo.getRecentActivities(studentId),
      ]);

      final counts = results[0] as Map<String, int>;
      final progress = results[1] as List<Map<String, dynamic>>;
      final activities = results[2] as List<Map<String, dynamic>>;

      return {
        'clearedCount': counts['cleared']!,
        'unclearedCount': counts['uncleared']!,
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
