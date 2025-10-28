import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_student_controller.dart';
import 'package:ucs/data/models/enums.dart';

class AdminStudentsView extends GetView<AdminStudentController> {
  const AdminStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator.adaptive(
        onRefresh: controller.fetchStudents,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search by name or matric number",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (query) {
                    controller.search(query);
                  },
                ),
              ),
            ),

            // --- Student List ---
            Obx(() {
              if (controller.isLoading.value) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SpinKitChasingDots(color: scheme.primary, size: 48),
                  ),
                );
              }

              final students = controller.students;

              if (students.isEmpty) {
                final q = controller.query.value.trim();
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      q.isEmpty ? "No students found" : "No results for ‘$q’",
                      style: AppFont.bodyMedium,
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.separated(
                  itemCount: students.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final s = students[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: scheme.primary,
                          child: Text(
                            (s['name'] ?? 'S')[0].toUpperCase(),
                            style: AppFont.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(s['name'] ?? '', style: AppFont.bodyLarge),
                        subtitle: Text(
                          "${s['matricNo'] ?? ''} • ${s['department'] ?? '-'}",
                          style: AppFont.bodySmall,
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            final id = s['id'] ?? '';
                            if (id.isEmpty) return;
                            if (value == 'view') {
                              await showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder: (_) => Padding(
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 16,
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom +
                                        24,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: scheme.primary,
                                            child: Text(
                                              (s['name'] ?? 'S')
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: AppFont.bodyMedium
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  s['name'] ?? '',
                                                  style: AppFont.titleMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _chip(
                                                      context,
                                                      label:
                                                          s['matricNo'] ?? '',
                                                    ),
                                                    _statusChip(
                                                      context,
                                                      s['status'] ?? 'pending',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      _detailRow(
                                        'Faculty',
                                        s['faculty'] ?? '-',
                                      ),
                                      _detailRow(
                                        'Department',
                                        s['department'] ?? '-',
                                      ),
                                      _detailRow('Level', s['level'] ?? '-'),
                                      _detailRow('Email', s['email'] ?? '-'),
                                      _detailRow('Phone', s['phone'] ?? '-'),
                                      _detailRow('Gender', s['gender'] ?? '-'),
                                    ],
                                  ),
                                ),
                              );
                            } else if (value == 'reset') {
                              final pwdCtrl = TextEditingController();
                              final confCtrl = TextEditingController();
                              await Get.defaultDialog(
                                title: 'Reset Password',
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: pwdCtrl,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'New Password',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: confCtrl,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Confirm Password',
                                      ),
                                    ),
                                  ],
                                ),
                                textCancel: 'Cancel',
                                textConfirm: 'Reset',
                                confirmTextColor: Colors.white,
                                onConfirm: () async {
                                  final p = pwdCtrl.text.trim();
                                  final c = confCtrl.text.trim();
                                  if (p.isEmpty || c.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Both fields are required',
                                      backgroundColor: Colors.red[50],
                                    );
                                    return;
                                  }
                                  if (p.length < 6) {
                                    Get.snackbar(
                                      'Error',
                                      'Password must be at least 6 characters',
                                      backgroundColor: Colors.red[50],
                                    );
                                    return;
                                  }
                                  if (p != c) {
                                    Get.snackbar(
                                      'Error',
                                      'Passwords do not match',
                                      backgroundColor: Colors.red[50],
                                    );
                                    return;
                                  }
                                  Get.back();
                                  await controller.resetStudentPasswordById(
                                    id,
                                    p,
                                  );
                                },
                              );
                            } else if (value == 'delete') {
                              await Get.defaultDialog(
                                title: 'Delete Student',
                                middleText:
                                    'Are you sure you want to delete this student? This action cannot be undone.',
                                textCancel: 'Cancel',
                                textConfirm: 'Delete',
                                confirmTextColor: Colors.white,
                                onConfirm: () async {
                                  Get.back();
                                  await controller.deleteStudentById(id);
                                },
                              );
                            } else if (value == 'status') {
                              // Change status sheet
                              final current = (s['status'] ?? 'pending')
                                  .toLowerCase();
                              StudentStatus selected = StudentStatus.pending;
                              if (current == 'cleared') {
                                selected = StudentStatus.cleared;
                              }
                              if (current == 'suspended') {
                                selected = StudentStatus.suspended;
                              }

                              await showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder: (ctx) {
                                  StudentStatus temp = selected;
                                  final scheme2 = Theme.of(ctx).colorScheme;
                                  return StatefulBuilder(
                                    builder: (ctx, setState) => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        16,
                                        16,
                                        24,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Change Status',
                                            style: AppFont.titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          RadioListTile<StudentStatus>(
                                            value: StudentStatus.pending,
                                            groupValue: temp,
                                            onChanged: (v) =>
                                                setState(() => temp = v!),
                                            title: Text(
                                              'Pending',
                                              style: AppFont.bodyMedium,
                                            ),
                                            activeColor: scheme2.primary,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          RadioListTile<StudentStatus>(
                                            value: StudentStatus.cleared,
                                            groupValue: temp,
                                            onChanged: (v) =>
                                                setState(() => temp = v!),
                                            title: Text(
                                              'Cleared',
                                              style: AppFont.bodyMedium,
                                            ),
                                            activeColor: scheme2.primary,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          RadioListTile<StudentStatus>(
                                            value: StudentStatus.suspended,
                                            groupValue: temp,
                                            onChanged: (v) =>
                                                setState(() => temp = v!),
                                            title: Text(
                                              'Suspended',
                                              style: AppFont.bodyMedium,
                                            ),
                                            activeColor: scheme2.primary,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(),
                                                child: const Text('Cancel'),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.of(ctx).pop();
                                                  await controller
                                                      .changeStudentStatusById(
                                                        id,
                                                        temp,
                                                      );
                                                },
                                                child: const Text('Update'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'view',
                              child: Text('View Profile'),
                            ),
                            PopupMenuItem(
                              value: 'reset',
                              child: Text('Reset Password'),
                            ),
                            PopupMenuItem(
                              value: 'status',
                              child: Text('Change Status'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: AppFont.bodySmall)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: AppFont.bodyMedium)),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, {required String label}) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(label, style: AppFont.bodySmall),
    );
  }

  Widget _statusChip(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;
    Color bg = scheme.surfaceContainerHighest;
    Color fg = scheme.onSurfaceVariant;
    switch (status.toLowerCase()) {
      case 'cleared':
        bg = scheme.secondaryContainer;
        fg = scheme.onSecondaryContainer;
        break;
      case 'in_progress':
        bg = scheme.tertiaryContainer;
        fg = scheme.onTertiaryContainer;
        break;
      case 'suspended':
        bg = scheme.errorContainer;
        fg = scheme.onErrorContainer;
        break;
      default:
        bg = scheme.surfaceContainerHighest;
        fg = scheme.onSurfaceVariant;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(status, style: AppFont.bodySmall.copyWith(color: fg)),
    );
  }
}
