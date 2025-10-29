import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/student/controllers/student_profile_controller.dart';

class StudentProfileView extends GetView<StudentProfileController> {
  const StudentProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.firstName.value.isEmpty) {
          return Center(
            child: SpinKitChasingDots(
              color: theme.colorScheme.primary,
              size: 50,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                // Profile Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => CircleAvatar(
                          radius: 48,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            controller.initials,
                            style: AppFont.titleLarge.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Text(
                          controller.fullName,
                          style: AppFont.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          '${controller.department.value} Student',
                          style: AppFont.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        final colors = controller.getStatusColors(context);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colors.$1,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: colors.$2,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                controller.statusText,
                                style: AppFont.bodySmall.copyWith(
                                  color: colors.$2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Personal Info
                Obx(
                  () => _sectionCard(
                    title: "Personal Information",
                    children: [
                      _infoRow("Matric Number", controller.matricNo.value),
                      if (controller.email.value.isNotEmpty)
                        _infoRow("Email", controller.email.value),
                      if (controller.phoneNumber.value.isNotEmpty)
                        _infoRow("Phone", controller.phoneNumber.value),
                      _infoRow("Faculty", controller.faculty.value),
                      _infoRow("Department", controller.department.value),
                      _infoRow("Level", controller.level.value),
                      if (controller.gender.value.isNotEmpty)
                        _infoRow("Gender", controller.gender.value),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: controller.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.errorContainer,
                      foregroundColor: theme.colorScheme.onErrorContainer,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text("Log Out"),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Section Card Wrapper
  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppFont.titleSmall),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  /// Info Row
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppFont.bodySmall),
          Flexible(
            child: Text(
              value,
              style: AppFont.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
