import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/data/models/student.dart';

class StudentRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final String _table = 'students';

  Future<void> addStudent(Student student) async {
    try {
      await _client.from(_table).insert(student.toJson());
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  Future<List<Student>> getStudents() async {
    try {
      final result = await _client.from(_table).select();
      return (result as List).map((e) => Student.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<bool> studentExists(String matricNo) async {
    try {
      final result = await _client
          .from(_table)
          .select('id')
          .eq('matric_no', matricNo)
          .limit(1);
      return result.isNotEmpty;
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error checking existing student: $e');
    }
  }
}
