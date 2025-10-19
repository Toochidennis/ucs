import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/user_device.dart';
import 'package:ucs/data/repositories/user_device_repository.dart';

class UserDeviceService {
  final _repo = UserDeviceRepository();

  Future<void> registerDevice({
    required String userId,
    required UserRole userRole,
    required String fcmToken,
    String? deviceName,
    String? platform,
  }) async {
    final device = UserDevice.newDevice(
      userId: userId,
      userRole: userRole.value,
      fcmToken: fcmToken,
      deviceName: deviceName,
      platform: platform,
    );

    await _repo.upsertDevice(device);
  }

  Future<void> removeDevice(String userId, String fcmToken) async {
    await _repo.deleteDevice(userId, fcmToken);
  }

  Future<List<UserDevice>> getUserDevices(String userId) async {
    return await _repo.getDevicesByUser(userId);
  }

  Future<void> refreshActivity(String fcmToken) async {
    await _repo.updateLastActive(fcmToken);
  }
}
