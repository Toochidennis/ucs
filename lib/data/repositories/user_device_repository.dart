import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ucs/data/models/user_device.dart';

class UserDeviceRepository {
  final _client = Supabase.instance.client;
  final String _table = 'user_devices';

  Future<void> upsertDevice(UserDevice device) async {
    try {
      await _client.from(_table).upsert(device.toJson());
    } on PostgrestException catch (e) {
      throw Exception('Failed to save device: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteDevice(String userId, String fcmToken) async {
    try {
      await _client
          .from(_table)
          .delete()
          .eq('user_id', userId)
          .eq('fcm_token', fcmToken);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete device: ${e.message}');
    }
  }

  Future<List<UserDevice>> getDevicesByUser(String userId) async {
    try {
      final result = await _client.from(_table).select().eq('user_id', userId);
      return (result as List).map((e) => UserDevice.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch devices: ${e.message}');
    }
  }

  Future<void> updateLastActive(String fcmToken) async {
    try {
      await _client
          .from(_table)
          .update({'last_active': DateTime.now().toIso8601String()})
          .eq('fcm_token', fcmToken);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update activity: ${e.message}');
    }
  }
}
