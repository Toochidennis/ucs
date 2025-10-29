import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/student/controllers/clearance_unit_controller.dart';

class ClearanceUnitView extends GetView<ClearanceUnitController> {
  const ClearanceUnitView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.clearanceUnits.isEmpty) {
          return Center(
            child: SpinKitChasingDots(color: scheme.primary, size: 50),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshUnits,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clearance Process',
                        style: AppFont.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete each unit in order to proceed',
                        style: AppFont.bodyMedium.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Progress Indicator
                      Obx(() {
                        final total = controller.clearanceUnits.length;
                        final cleared = controller.clearanceUnits
                            .where((u) => u['status'] == 'approved')
                            .length;
                        final progress = total > 0 ? cleared / total : 0.0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Overall Progress',
                                  style: AppFont.titleSmall,
                                ),
                                Text(
                                  '$cleared of $total',
                                  style: AppFont.titleSmall.copyWith(
                                    color: scheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: scheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress == 1.0
                                      ? Colors.green
                                      : scheme.primary,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Clearance Units List
              Obx(() {
                if (controller.clearanceUnits.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No clearance units available')),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final unit = controller.clearanceUnits[index];
                      return _buildUnitCard(
                        context,
                        unit,
                        index < controller.clearanceUnits.length - 1,
                      );
                    }, childCount: controller.clearanceUnits.length),
                  ),
                );
              }),

              // Certificate Section
              Obx(() {
                if (controller.allUnitsCleared.value) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _buildCertificateCard(context),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      }),
    );
  }

  /// Build individual unit card
  Widget _buildUnitCard(
    BuildContext context,
    Map<String, dynamic> unit,
    bool showConnector,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final isAccessible = unit['isAccessible'] as bool;
    final status = unit['status'] as String;
    final color = unit['color'] as Color;

    return Column(
      children: [
        Opacity(
          opacity: isAccessible ? 1.0 : 0.5,
          child: Card(
            elevation: isAccessible ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isAccessible
                    ? color.withOpacity(0.3)
                    : scheme.outlineVariant,
                width: 1.5,
              ),
            ),
            child: InkWell(
              onTap: () => controller.onUnitTap(unit),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Position and Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isAccessible
                            ? color.withOpacity(0.15)
                            : scheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '${unit['position']}',
                            style: AppFont.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isAccessible
                                  ? color
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                          if (!isAccessible)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: scheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Unit Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit['unitName'] as String,
                            style: AppFont.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                unit['icon'] as IconData,
                                size: 16,
                                color: color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                unit['statusText'] as String,
                                style: AppFont.bodySmall.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Arrow or Status Icon
                    if (isAccessible)
                      Icon(
                        status == 'approved'
                            ? Icons.check_circle
                            : Icons.arrow_forward_ios,
                        color: status == 'approved' ? Colors.green : color,
                        size: 20,
                      )
                    else
                      Icon(
                        Icons.lock_outline,
                        color: scheme.onSurfaceVariant,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Connector line
        if (showConnector)
          Container(
            margin: const EdgeInsets.only(left: 43),
            width: 2,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.withOpacity(0.5), scheme.outlineVariant],
              ),
            ),
          ),
      ],
    );
  }

  /// Build certificate download card
  Widget _buildCertificateCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Success Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Congratulations! 🎉',
                style: AppFont.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                'You have completed all clearance units. Download your certificate now.',
                style: AppFont.bodyMedium.copyWith(
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Download Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.downloadCertificate,
                  icon: const Icon(Icons.download),
                  label: const Text('Download Certificate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
