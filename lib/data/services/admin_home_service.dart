import 'package:ucs/data/repositories/admin_home_repository.dart';

class AdminHomeService {
  final _repo = AdminHomeRepository();

  Future<Map<String, dynamic>> getDashboardMetrics({
    Duration window = const Duration(days: 7),
  }) {
    return _repo.getDashboardMetrics(window: window);
  }

  Future<List<Map<String, dynamic>>> getRecentActivities() {
    return _repo.getRecentActivities();
  }
}
