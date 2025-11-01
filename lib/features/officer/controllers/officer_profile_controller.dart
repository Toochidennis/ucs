import 'package:get/get.dart';

class OfficerProfileController extends GetxController {
  // Profile fields
  var firstName = "".obs;
  var lastName = "".obs;
  var department = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var isLoading = false.obs;

  String get fullName => "${firstName.value} ${lastName.value}";

  String get initials {
    String firstInitial =
        firstName.value.isNotEmpty ? firstName.value[0] : "";
    String lastInitial = lastName.value.isNotEmpty ? lastName.value[0] : "";
    return (firstInitial + lastInitial).toUpperCase();
  }

  Future<void> refreshProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    // Simulate fetching updated profile data here
    isLoading.value = false;
  }
}