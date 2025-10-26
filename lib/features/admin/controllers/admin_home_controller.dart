import 'package:get/get.dart';
import 'package:ucs/data/services/admin_home_service.dart';

class AdminHomeController extends GetxController {
  final _svc = AdminHomeService();

  // Totals
  final totalStudents = 0.obs;
  final totalOfficers = 0.obs;
  final totalPending = 0.obs;
  final totalCleared = 0.obs;

  // Trends (true => up or equal; false => down)
  final studentsTrendUp = false.obs;
  final officersTrendUp = false.obs;
  final pendingTrendUp = false.obs;
  final clearedTrendUp = false.obs;

  final isLoading = false.obs;
  final isLoadingActivities = false.obs;
  final recentActivities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
    loadRecentActivities();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      final metrics = await _svc.getDashboardMetrics();
      totalStudents.value = metrics['students']['total'] as int;
      studentsTrendUp.value = metrics['students']['trendUp'] as bool;

      totalOfficers.value = metrics['officers']['total'] as int;
      officersTrendUp.value = metrics['officers']['trendUp'] as bool;

      totalPending.value = metrics['pendingClearances']['total'] as int;
      pendingTrendUp.value = metrics['pendingClearances']['trendUp'] as bool;

      totalCleared.value = metrics['clearedClearances']['total'] as int;
      clearedTrendUp.value = metrics['clearedClearances']['trendUp'] as bool;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRecentActivities({int limit = 10}) async {
    isLoadingActivities.value = true;
    try {
      final items = await _svc.getRecentActivities();
      recentActivities.assignAll(items);
    } finally {
      isLoadingActivities.value = false;
    }
  }
}
