import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/data/services/officer_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminOfficerController extends GetxController {
  final _service = OfficerService();
  final officers = <Map<String, String>>[].obs; // filtered, drives UI
  final isLoading = false.obs;
  final query = ''.obs;

  // Keep an unfiltered snapshot to support search
  final List<Map<String, String>> _allOfficers = [];

  @override
  void onInit() {
    super.onInit();
    loadOfficers();
  }

  Future<void> loadOfficers() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchAllOfficers();
      final mapped = data
          .map(
            (o) => {
              "id": o.id,
              "name": o.name,
              "unit": o.unitName ?? 'All',
              "email": o.email ?? '',
            },
          )
          .toList();
      _allOfficers
        ..clear()
        ..addAll(mapped);
      _applyFilter();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to load officers. Please try again later.",
        backgroundColor: Colors.red[50],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetOfficerPasswordById(String id, String newPassword) async {
    // show small loading overlay
    await _withOverlay(() async {
      await _service.resetOfficerPassword(id, newPassword);
      Get.snackbar(
        "Password Reset",
        "Password reset successfully.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[50],
      );
    });
  }

  Future<void> removeOfficerById(String id) async {
    await _withOverlay(() async {
      await _service.removeOfficer(id);
      // Update local lists
      _allOfficers.removeWhere((o) => o['id'] == id);
      officers.removeWhere((o) => o['id'] == id);
      Get.snackbar(
        "Removed",
        "Officer removed successfully.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[50],
      );
    });
  }

  Future<void> _withOverlay(Future<void> Function() action) async {
    // Use root navigator to avoid being nested under any active dialogs
    showDialog(
      context: Get.context!,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: SpinKitChasingDots(color: Colors.blue, size: 48)),
    );
    try {
      await action();
    } finally {
      // Ensure we close the spinner even if other overlays are present
      if (Get.isDialogOpen == true) {
        Get.back();
      } else {
        try {
          Navigator.of(Get.context!, rootNavigator: true).pop();
        } catch (_) {}
      }
    }
  }

  void search(String q) {
    query.value = q;
    _applyFilter();
  }

  void _applyFilter() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      officers.assignAll(_allOfficers);
      return;
    }
    officers.assignAll(
      _allOfficers.where((o) {
        final name = (o['name'] ?? '').toLowerCase();
        final unit = (o['unit'] ?? '').toLowerCase();
        final email = (o['email'] ?? '').toLowerCase();
        return name.contains(q) || unit.contains(q) || email.contains(q);
      }),
    );
  }
}
