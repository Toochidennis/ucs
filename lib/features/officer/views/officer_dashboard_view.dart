import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import '../controllers/officer_controller.dart';

class OfficerDashboardView extends GetView<OfficerController> {
  const OfficerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.showDetail.value)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.black),
                      onPressed: controller.backToDashboard,
                    )
                  else
                    const SizedBox(width: 48),
                  Text(
                    controller.headerTitle.value,
                    style: AppFont.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(AppColor.onBackground),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(AppColor.primary),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.person_outline,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.showDetail.value
                    ? _buildDetailView()
                    : _buildDashboardTabs(),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ---------------- Dashboard View ----------------
  Widget _buildDashboardTabs() {
    return Column(
      children: [
        // Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _tabButton("Pending", 0),
              _tabButton("Approved", 1),
              _tabButton("Rejected", 2),
            ],
          ),
        ),
        const Divider(height: 1),

        // Student list
        Expanded(
          child: Obx(() {
            final currentTab = controller.currentTab.value;
            final students = controller.getStudentsForTab(currentTab);

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (_, i) {
                final s = students[i];
                return GestureDetector(
                  onTap: () => controller.openStudentDetail(s['name']),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['matric'],
                                style: AppFont.bodySmall
                                    .copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(s['name'], style: AppFont.bodyMedium),
                          ],
                        ),
                        if (currentTab == 0)
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 16)
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: currentTab == 1
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentTab == 1 ? "Approved" : "Rejected",
                              style: AppFont.caption.copyWith(
                                color: currentTab == 1
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // Tab Button
  Widget _tabButton(String label, int index) {
    final isActive = controller.currentTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? const Color(AppColor.primary)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppFont.bodyMedium.copyWith(
              color: isActive
                  ? const Color(AppColor.primary)
                  : Colors.grey.shade600,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Detail View ----------------
  Widget _buildDetailView() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Clearance Documents", style: AppFont.titleSmall),
              const SizedBox(height: 16),

              // Document Grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: controller.documents.length,
                itemBuilder: (_, i) {
                  final doc = controller.documents[i];
                  return GestureDetector(
                    onTap: () => controller.openDocument(doc),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            doc['image']!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(doc['title']!,
                            textAlign: TextAlign.center,
                            style: AppFont.bodySmall.copyWith(
                                color: const Color(AppColor.onSurface))),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Action Buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            children: [
              Obx(() => controller.showCommentBox.value
                  ? TextField(
                      controller: controller.commentCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter rejection reason...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.approveRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Approve"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.rejectRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Reject"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
