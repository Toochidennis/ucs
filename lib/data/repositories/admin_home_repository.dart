import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHomeRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // --- Totals ---
  Future<int> _getTotalStudents() async {
    final data = await _client.from('students').select('id');
    return (data as List).length;
  }

  Future<int> _getTotalOfficers() async {
    final data = await _client.from('officers').select('id');
    return (data as List).length;
  }

  Future<int> _getTotalPendingClearances() async {
    final data = await _client
        .from('students')
        .select('id')
        .eq('status', 'pending');
    return (data as List).length;
  }

  Future<int> _getTotalClearedClearances() async {
    final data = await _client
        .from('students')
        .select('id')
        .eq('status', 'cleared');
    return (data as List).length;
  }

  // --- Trends (current window vs previous window) ---
  Future<bool> _isStudentsTrendUp({
    Duration window = const Duration(days: 7),
  }) async {
    return _isTrendUp(table: 'students', window: window);
  }

  Future<bool> _isOfficersTrendUp({
    Duration window = const Duration(days: 7),
  }) async {
    return _isTrendUp(table: 'officers', window: window);
  }

  Future<bool> _isPendingClearancesTrendUp({
    Duration window = const Duration(days: 7),
  }) async {
    return _isTrendUp(
      table: 'students',
      window: window,
      statusField: 'status',
      statusValue: 'pending',
    );
  }

  Future<bool> _isClearedClearancesTrendUp({
    Duration window = const Duration(days: 7),
  }) async {
    return _isTrendUp(
      table: 'students',
      window: window,
      statusField: 'status',
      statusValue: 'cleared',
    );
  }

  Future<bool> _isTrendUp({
    required String table,
    required Duration window,
    String? statusField,
    String? statusValue,
  }) async {
    final now = DateTime.now().toUtc();
    final currentStart = now.subtract(window);
    final previousStart = currentStart.subtract(window);

    final current = await _countBetween(
      table: table,
      start: currentStart,
      end: now,
      statusField: statusField,
      statusValue: statusValue,
    );
    final previous = await _countBetween(
      table: table,
      start: previousStart,
      end: currentStart,
      statusField: statusField,
      statusValue: statusValue,
    );
    return current >= previous;
  }

  Future<int> _countBetween({
    required String table,
    required DateTime start,
    required DateTime end,
    String? statusField,
    String? statusValue,
  }) async {
    var query = _client
        .from(table)
        .select('id')
        .gte('created_at', start.toIso8601String())
        .lt('created_at', end.toIso8601String());
    if (statusField != null && statusValue != null) {
      query = query.eq(statusField, statusValue);
    }
    final data = await query;
    return (data as List).length;
  }

  // Convenience: get all metrics in a single call
  Future<Map<String, dynamic>> getDashboardMetrics({
    Duration window = const Duration(days: 7),
  }) async {
    final totalStudents = await _getTotalStudents();
    final totalOfficers = await _getTotalOfficers();
    final totalPending = await _getTotalPendingClearances();
    final totalCleared = await _getTotalClearedClearances();
    final studentsUp = await _isStudentsTrendUp(window: window);
    final officersUp = await _isOfficersTrendUp(window: window);
    final pendingUp = await _isPendingClearancesTrendUp(window: window);
    final clearedUp = await _isClearedClearancesTrendUp(window: window);

    return {
      'students': {'total': totalStudents, 'trendUp': studentsUp},
      'officers': {'total': totalOfficers, 'trendUp': officersUp},
      'pendingClearances': {'total': totalPending, 'trendUp': pendingUp},
      'clearedClearances': {'total': totalCleared, 'trendUp': clearedUp},
    };
  }

  /// Recent activities across the system.
  /// Combines recent student submissions and officer reviews (approve/reject), sorted by time desc.
  /// Returns latest 10 items with enriched names when possible.
  /// Assumptions:
  /// - Documents table name: 'clearance_documents'
  /// - Fields: id, student_id, unit_id, requirement_id, submitted_at, reviewed_by, reviewed_at, status
  Future<List<Map<String, dynamic>>> getRecentActivities({
    int limit = 10,
  }) async {
    // Fetch recent submissions
    final submissionsRaw = await _client
        .from('clearance_documents')
        .select('id, student_id, unit_id, submitted_at, status')
        .order('submitted_at', ascending: false)
        .limit(limit);

    // Fetch recent reviews (approved/rejected) where reviewed_at is not null
    final reviewsRaw = await _client
        .from('clearance_documents')
        .select('id, student_id, unit_id, reviewed_by, reviewed_at, status')
        .not('reviewed_at', 'is', null)
        .order('reviewed_at', ascending: false)
        .limit(limit);

    final List subList = (submissionsRaw as List? ?? []);
    final List revList = (reviewsRaw as List? ?? []);

    // Collect student and officer ids to enrich names
    final studentIds = <String>{}
      ..addAll(subList.map((e) => e['student_id'] as String))
      ..addAll(revList.map((e) => e['student_id'] as String));
    final officerIds = <String>{}
      ..addAll(revList.map((e) => (e['reviewed_by'] as String?) ?? ''))
      ..removeWhere((e) => e.isEmpty);

    // Bulk fetch student names
    Map<String, Map<String, dynamic>> studentsById = {};
    if (studentIds.isNotEmpty) {
      final studentsRaw = await _client
          .from('students')
          .select('id, first_name, middle_name, last_name, matric_no')
          .inFilter('id', studentIds.toList());
      for (final s in (studentsRaw as List)) {
        studentsById[s['id'] as String] = Map<String, dynamic>.from(s);
      }
    }

    // Bulk fetch officer names
    Map<String, Map<String, dynamic>> officersById = {};
    if (officerIds.isNotEmpty) {
      final officersRaw = await _client
          .from('officers')
          .select('id, name, officer_id')
          .inFilter('id', officerIds.toList());
      for (final o in (officersRaw as List)) {
        officersById[o['id'] as String] = Map<String, dynamic>.from(o);
      }
    }

    String fullName(Map<String, dynamic>? s) {
      if (s == null) return '';
      final first = (s['first_name'] ?? '').toString().trim();
      final middle = (s['middle_name'] ?? '').toString().trim();
      final last = (s['last_name'] ?? '').toString().trim();
      return [first, middle, last].where((p) => p.isNotEmpty).join(' ');
    }

    final List<Map<String, dynamic>> activities = [];

    // Map submissions
    for (final e in subList) {
      final sid = e['student_id'] as String;
      final student = studentsById[sid];
      final submittedAt = e['submitted_at'] as String?;
      activities.add({
        'type': 'submission',
        'time': submittedAt != null
            ? DateTime.parse(submittedAt)
            : DateTime.now(),
        'status': (e['status'] ?? 'pending').toString(),
        'studentId': sid,
        'studentName': fullName(student),
        'matricNo': student?['matric_no'],
        'unitId': e['unit_id'],
        'title': 'Document submitted',
        'by': fullName(student),
      });
    }

    // Map reviews
    for (final e in revList) {
      final sid = e['student_id'] as String;
      final student = studentsById[sid];
      final oid = e['reviewed_by'] as String?;
      final officer = oid != null ? officersById[oid] : null;
      final status = (e['status'] ?? '').toString().toLowerCase();
      final action = status == 'approved'
          ? 'approved'
          : status == 'rejected'
          ? 'rejected'
          : 'reviewed';
      final reviewedAt = e['reviewed_at'] as String?;
      activities.add({
        'type': 'review',
        'time': reviewedAt != null
            ? DateTime.parse(reviewedAt)
            : DateTime.now(),
        'status': status,
        'studentId': sid,
        'studentName': fullName(student),
        'matricNo': student?['matric_no'],
        'unitId': e['unit_id'],
        'officerId': oid,
        'officerName': officer?['name'],
        'title': 'Clearance $action',
        'by': officer?['name'],
      });
    }

    // Sort by time desc and take top N
    activities.sort(
      (a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime),
    );
    if (activities.length > limit) {
      return activities.sublist(0, limit);
    }
    return activities;
  }
}
