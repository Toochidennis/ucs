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

  /// Get optimized clearance counts for a student (cleared and uncleared)
  /// Returns a map with both counts in a single optimized query
  Future<Map<String, int>> getClearanceCounts(String studentId) async {
    try {
      // Get all units with their requirements in one query
      final unitsResponse = await _client
          .from('clearance_units')
          .select('id, clearance_requirements(id)');

      final units = unitsResponse as List;
      final totalUnits = units.length;

      if (units.isEmpty) {
        return {'cleared': 0, 'uncleared': 0};
      }

      // Get all documents for this student in ONE query
      final allDocs = await _client
          .from('clearance_documents')
          .select('unit_id, requirement_id, status')
          .eq('student_id', studentId)
          .eq('status', 'approved');

      // Group documents by unit_id for quick lookup
      final docsByUnit = <String, Set<String>>{};
      for (final doc in allDocs as List) {
        final unitId = doc['unit_id'] as String;
        final reqId = doc['requirement_id'] as String;
        docsByUnit.putIfAbsent(unitId, () => <String>{}).add(reqId);
      }

      // Count cleared units
      int clearedCount = 0;
      for (final unitData in units) {
        final unitId = unitData['id'] as String;
        final requirements = unitData['clearance_requirements'] as List?;

        if (requirements == null || requirements.isEmpty) {
          continue;
        }

        final requirementIds = requirements
            .map((r) => r['id'] as String)
            .toSet();

        final approvedReqs = docsByUnit[unitId] ?? <String>{};

        // Check if all requirements are approved
        if (approvedReqs.containsAll(requirementIds)) {
          clearedCount++;
        }
      }

      return {'cleared': clearedCount, 'uncleared': totalUnits - clearedCount};
    } on PostgrestException catch (e) {
      throw Exception('Failed to get clearance counts: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get clearance counts: $e');
    }
  }

  /// Get count of cleared units for a student
  /// Get clearance progress for each unit - OPTIMIZED VERSION
  /// Returns a list of maps with unit details and their status
  /// Uses only 2 queries instead of N+1 queries
  Future<List<Map<String, dynamic>>> getClearanceProgress(
    String studentId,
  ) async {
    try {
      // QUERY 1: Get all units with their requirements
      final unitsResponse = await _client
          .from('clearance_units')
          .select('id, unit_name, position, clearance_requirements(id)')
          .order('position', ascending: true);

      final units = unitsResponse as List;

      if (units.isEmpty) {
        return [];
      }

      // QUERY 2: Get ALL documents for this student in ONE query
      final allDocs = await _client
          .from('clearance_documents')
          .select('unit_id, requirement_id, status')
          .eq('student_id', studentId);

      // Group documents by unit_id for quick lookup
      final docsByUnit = <String, List<Map<String, dynamic>>>{};
      for (final doc in allDocs as List) {
        final unitId = doc['unit_id'] as String;
        docsByUnit.putIfAbsent(unitId, () => []).add(doc);
      }

      // Build progress list
      final progressList = <Map<String, dynamic>>[];

      for (final unitData in units) {
        final unitId = unitData['id'] as String;
        final unitName = unitData['unit_name'] as String;
        final requirements = unitData['clearance_requirements'] as List?;

        if (requirements == null || requirements.isEmpty) {
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
            .toSet();

        final unitDocs = docsByUnit[unitId] ?? [];

        if (unitDocs.isEmpty) {
          progressList.add({
            'unitId': unitId,
            'unitName': unitName,
            'status': 'not_started',
            'icon': 'more_horiz',
            'color': 'grey',
          });
        } else {
          // Count statuses
          final approvedCount = unitDocs
              .where((d) => d['status'] == 'approved')
              .length;
          final rejectedCount = unitDocs
              .where((d) => d['status'] == 'rejected')
              .length;

          if (approvedCount == requirementIds.length) {
            progressList.add({
              'unitId': unitId,
              'unitName': unitName,
              'status': 'approved',
              'icon': 'check',
              'color': 'green',
            });
          } else if (rejectedCount > 0) {
            progressList.add({
              'unitId': unitId,
              'unitName': unitName,
              'status': 'rejected',
              'icon': 'close',
              'color': 'red',
            });
          } else {
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
