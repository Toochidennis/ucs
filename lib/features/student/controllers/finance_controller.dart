import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class FinanceController extends GetxController {
  var uploadedFiles = <String>[].obs;
  var stepProgress = 0.11.obs;
  var status = "pending".obs;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      uploadedFiles.addAll(result.files.map((f) => f.name));
    }
  }

  void removeFile(String file) {
    uploadedFiles.remove(file);
  }

  void submit() {
    if (uploadedFiles.length < 4) {
      Get.snackbar(
        'Incomplete',
        'Please upload all required documents before submitting.',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      status.value = "submitted";
      Get.snackbar(
        'Success',
        'Documents submitted successfully!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void saveDraft() {
    Get.snackbar(
      'Saved',
      'Draft saved successfully!',
      snackPosition: SnackPosition.TOP,
    );
  }
}
