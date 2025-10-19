import 'package:firebase_messaging/firebase_messaging.dart';

class FcmUtil {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Retrieves the current device's FCM token.
  /// Automatically refreshes and handles permission requests.
  static Future<String?> getDeviceToken() async {
    try {
      // Request permissions on iOS / macOS (no effect on Android)
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // Retrieve the current token
      String? token = await _fcm.getToken();

      // Listen for token refresh (important for re-registration)
      _fcm.onTokenRefresh.listen((newToken) {
        token = newToken;
      });

      return token;
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null;
    }
  }

  /// Deletes the existing FCM token (useful on logout)
  static Future<void> deleteToken() async {
    try {
      await _fcm.deleteToken();
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}
