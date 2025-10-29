import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/data/models/clearance_unit.dart';

class StudentHomeRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get all clearance units ordered by position
  Future<List<ClearanceUnit>> fetchClearanceUnits() async {
    try {
      final response = await _client
          .from('clearance_units')
          .select('*, clearance_requirements(*)')
          .order('position', ascending: true);

      return (response as List)
          .map((json) => ClearanceUnit.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch clearance units: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch clearance units: $e');
    }
  }

  /// Get count of cleared units for a student
  /// A unit is considered cleared when all its requirements are approved
  Future<int> getClearedUnitsCount(String studentId) async {
    try {
      // Get all units
      final unitsResponse = await _client
          .from('clearance_units')
          .select('id, clearance_requirements(id)');

      int clearedCount = 0;

      for (final unitData in unitsResponse as List) {
        final unitId = unitData['id'] as String;
        final requirements = unitData['clearance_requirements'] as List?;

        if (requirements == null || requirements.isEmpty) {
          continue;
        }

        // Get all requirement IDs for this unit
        final requirementIds = requirements
            .map((r) => r['id'] as String)
            .toList();

        // Check if all requirements have approved documents
        final approvedDocs = await _client
            .from('clearance_documents')
            .select('requirement_id')
            .eq('student_id', studentId)
            .eq('unit_id', unitId)
            .eq('status', 'approved')
            .inFilter('requirement_id', requirementIds);

        // If all requirements have approved documents, count as cleared
        if (approvedDocs.length == requirementIds.length) {
          clearedCount++;
        }
      }

      return clearedCount;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get cleared units count: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get cleared units count: $e');
    }
  }

  /// Get count of uncleared (pending) units for a student
  Future<int> getUnclearedUnitsCount(String studentId) async {
    try {
      // Get total units count
      final totalUnitsResponse = await _client
          .from('clearance_units')
          .select('id');
      final totalUnits = (totalUnitsResponse as List).length;

      // Get cleared units count
      final clearedUnits = await getClearedUnitsCount(studentId);

      return totalUnits - clearedUnits;
    } catch (e) {
      throw Exception('Failed to get uncleared units count: $e');
    }
  }

  /// Get clearance progress for each unit
  /// Returns a list of maps with unit details and their status
  Future<List<Map<String, dynamic>>> getClearanceProgress(
    String studentId,
  ) async {
    try {
      // Get all units with their requirements
      final unitsResponse = await _client
          .from('clearance_units')
          .select('id, unit_name, position, clearance_requirements(id)')
          .order('position', ascending: true);

      final progressList = <Map<String, dynamic>>[];

      for (final unitData in unitsResponse as List) {
        final unitId = unitData['id'] as String;
        final unitName = unitData['unit_name'] as String;
        final requirements = unitData['clearance_requirements'] as List?;

        if (requirements == null || requirements.isEmpty) {
          // No requirements, mark as not started
          progressList.add({
            'unitId': unitId,
            'unitName': unitName,
            'status': 'not_started',
            'icon': 'more_horiz',
            'color': 'grey',
          });
          continue;
        }

        final requirementIds = requirements
            .map((r) => r['id'] as String)
            .toList();

        // Get documents for this unit
        final docs = await _client
            .from('clearance_documents')
            .select('status, requirement_id')
            .eq('student_id', studentId)
            .eq('unit_id', unitId)
            .inFilter('requirement_id', requirementIds);

        if (docs.isEmpty) {
          // No documents submitted
          progressList.add({
            'unitId': unitId,
            'unitName': unitName,
            'status': 'not_started',
            'icon': 'more_horiz',
            'color': 'grey',
          });
        } else {
          // Check statuses
          final approvedCount = docs
              .where((d) => d['status'] == 'approved')
              .length;
          final rejectedCount = docs
              .where((d) => d['status'] == 'rejected')
              .length;

          if (approvedCount == requirementIds.length) {
            // All approved
            progressList.add({
              'unitId': unitId,
              'unitName': unitName,
              'status': 'approved',
              'icon': 'check',
              'color': 'green',
            });
          } else if (rejectedCount > 0) {
            // At least one rejected
            progressList.add({
              'unitId': unitId,
              'unitName': unitName,
              'status': 'rejected',
              'icon': 'close',
              'color': 'red',
            });
          } else {
            // Some pending
            progressList.add({
              'unitId': unitId,
              'unitName': unitName,
              'status': 'pending',
              'icon': 'access_time',
              'color': 'orange',
            });
          }
        }
      }

      return progressList;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get clearance progress: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get clearance progress: $e');
    }
  }

  /// Get recent activities for a student
  /// Returns a list of recent document submissions and reviews
  Future<List<Map<String, dynamic>>> getRecentActivities(
    String studentId, {
    int limit = 5,
  }) async {
    try {
      final response = await _client
          .from('clearance_documents')
          .select('*, clearance_units(unit_name)')
          .eq('student_id', studentId)
          .order('submitted_at', ascending: false)
          .limit(limit);

      final activities = <Map<String, dynamic>>[];

      for (final doc in response as List) {
        final status = doc['status'] as String;
        final unitName =
            (doc['clearance_units'] as Map?)?['unit_name'] as String? ??
            'Unknown Unit';
        final submittedAt = DateTime.parse(doc['submitted_at']);
        final reviewedAt = doc['reviewed_at'] != null
            ? DateTime.parse(doc['reviewed_at'])
            : null;

        // Use the most recent timestamp
        final timestamp = reviewedAt ?? submittedAt;
        final timeDiff = DateTime.now().difference(timestamp);

        String timeAgo;
        if (timeDiff.inMinutes < 60) {
          timeAgo = '${timeDiff.inMinutes} minutes ago';
        } else if (timeDiff.inHours < 24) {
          timeAgo = '${timeDiff.inHours} hours ago';
        } else {
          timeAgo = '${timeDiff.inDays} days ago';
        }

        String title;
        String color;
        if (status == 'approved') {
          title = '$unitName clearance approved';
          color = 'green';
        } else if (status == 'rejected') {
          title = '$unitName clearance rejected';
          color = 'red';
        } else if (reviewedAt != null) {
          title = '$unitName under review';
          color = 'blue';
        } else {
          title = '$unitName documents submitted';
          color = 'blue';
        }

        activities.add({
          'title': title,
          'time': timeAgo,
          'color': color,
          'timestamp': timestamp,
        });
      }

      return activities;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get recent activities: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get recent activities: $e');
    }
  }

  /// Get student information by ID
  /// Returns student data including name and status
  Future<Map<String, dynamic>> getStudentById(String studentId) async {
    try {
      final response = await _client
          .from('students')
          .select(
            'id, first_name, middle_name, last_name, matric_no, email, '
            'phone_number, gender, faculty, department, level, status',
          )
          .eq('id', studentId)
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to get student info: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get student info: $e');
    }
  }
}
