import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/core/constants/app_color.dart';
import '../controllers/admin_controller.dart';
import 'package:fl_chart/fl_chart.dart'; // 📊 add in pubspec.yaml

class ReportsView extends GetView<AdminController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & Analytics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: implement export to CSV/PDF
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Summary cards
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: isWide ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard("Cleared", controller.totalCleared.value, AppColor.success, Icons.check_circle),
                _buildStatCard("Pending", controller.totalPending.value, AppColor.warning, Icons.hourglass_bottom),
                _buildStatCard("Rejected", controller.totalRejected.value, AppColor.error, Icons.cancel),
              ],
            ),

            const SizedBox(height: 20),

            // Faculty Bar Chart
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Clearance by Faculty", style: AppFont.titleMedium),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 120, color: const Color(AppColor.primary))], showingTooltipIndicators: [0]),
                            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 80, color: const Color(AppColor.secondary))], showingTooltipIndicators: [0]),
                            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 60, color: const Color(AppColor.error))], showingTooltipIndicators: [0]),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text("Science");
                                  case 1:
                                    return const Text("Law");
                                  case 2:
                                    return const Text("Engr.");
                                  default:
                                    return const Text("");
                                }
                              }),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pie Chart Example
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Clearance Status Distribution", style: AppFont.titleMedium),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: controller.totalCleared.value.toDouble(),
                              title: "Cleared",
                              color: const Color(AppColor.success),
                              radius: 60,
                              titleStyle: AppFont.bodySmall.copyWith(color: Colors.white),
                            ),
                            PieChartSectionData(
                              value: controller.totalPending.value.toDouble(),
                              title: "Pending",
                              color: const Color(AppColor.warning),
                              radius: 60,
                              titleStyle: AppFont.bodySmall.copyWith(color: Colors.white),
                            ),
                            PieChartSectionData(
                              value: controller.totalRejected.value.toDouble(),
                              title: "Rejected",
                              color: const Color(AppColor.error),
                              radius: 60,
                              titleStyle: AppFont.bodySmall.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value, int color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(color)),
            const SizedBox(height: 12),
            Text(
              "$value",
              style: AppFont.titleMedium.copyWith(color: Color(color)),
            ),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: AppFont.bodySmall),
          ],
        ),
      ),
    );
  }
}
