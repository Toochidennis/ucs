import 'package:get/get.dart';

class StudentProfileController extends GetxController {
  // Observables for settings
  var pushNotifications = true.obs;
  var emailUpdates = true.obs;

  /// Called when "Edit" button in header is tapped
  void editProfile() {
    // Navigate to edit profile screen (you can define your route)
    Get.toNamed('/student/profile/edit');
  }

  /// Toggle push notifications
  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
    // TODO: Save preference to Supabase/local storage
  }

  /// Toggle email updates
  void toggleEmailUpdates(bool value) {
    emailUpdates.value = value;
    // TODO: Save preference to Supabase/local storage
  }

  /// Handle logout
  void logout() {
    // Clear auth/session
    // Example for Supabase:
    // await Supabase.instance.client.auth.signOut();

    // Navigate back to login
    Get.offAllNamed('/auth/login');
  }
}
