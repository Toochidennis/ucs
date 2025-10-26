import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_officer_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminOfficersView extends GetView<AdminOfficerController> {
  const AdminOfficersView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // 🔍 Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by name or unit",
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

          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: SpinKitChasingDots(color: scheme.primary, size: 48),
                ),
              );
            }

            final officers = controller.officers; // filtered list
            if (officers.isEmpty) {
              final q = controller.query.value.trim();
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    q.isEmpty ? "No officers found" : "No results for '$q'",
                    style: AppFont.bodyMedium,
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemCount: officers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final officer = officers[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.primary,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        officer['name'] ?? '',
                        style: AppFont.bodyLarge,
                      ),
                      subtitle: Text(
                        "${officer['unit'] ?? '-'} • ${officer['email'] ?? ''}",
                        style: AppFont.bodySmall,
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) async {
                          final id = officer['id'];
                          if (id == null || id.isEmpty) return;
                          if (value == "view") {
                            Get.defaultDialog(
                              title: "Officer Details",
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Name: ${officer['name'] ?? ''}"),
                                  Text("Unit: ${officer['unit'] ?? '-'}"),
                                  Text("Email: ${officer['email'] ?? ''}"),
                                ],
                              ),
                              textConfirm: "Close",
                              onConfirm: () => Get.back(),
                            );
                          } else if (value == "reset") {
                            final pwdController = TextEditingController();
                            final confirmController = TextEditingController();
                            Get.defaultDialog(
                              title: "Reset Password",
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: pwdController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'New Password',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: confirmController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Confirm Password',
                                    ),
                                  ),
                                ],
                              ),
                              textCancel: "Cancel",
                              textConfirm: "Reset",
                              onConfirm: () async {
                                final pwd = pwdController.text.trim();
                                final conf = confirmController.text.trim();
                                if (pwd.isEmpty || conf.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Password and confirmation are required.",
                                    backgroundColor: Colors.red[50],
                                  );
                                  return;
                                }
                                if (pwd.length < 6) {
                                  Get.snackbar(
                                    "Error",
                                    "Password must be at least 6 characters.",
                                    backgroundColor: Colors.red[50],
                                  );
                                  return;
                                }
                                if (pwd != conf) {
                                  Get.snackbar(
                                    "Error",
                                    "Passwords do not match.",
                                    backgroundColor: Colors.red[50],
                                  );
                                  return;
                                }
                                Get.back();
                                await controller.resetOfficerPasswordById(
                                  id,
                                  pwd,
                                );
                              },
                            );
                          } else if (value == "remove") {
                            Get.defaultDialog(
                              title: "Remove Officer",
                              middleText:
                                  "Are you sure you want to remove this officer?",
                              textCancel: "Cancel",
                              textConfirm: "Remove",
                              confirmTextColor: Colors.white,
                              onConfirm: () async {
                                Get.back();
                                await controller.removeOfficerById(id);
                              },
                            );
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: "view",
                            child: Text("View Details"),
                          ),
                          PopupMenuItem(
                            value: "reset",
                            child: Text("Reset Password"),
                          ),
                          PopupMenuItem(
                            value: "remove",
                            child: Text("Remove Officer"),
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
    );
  }

  // _buildOfficerCard removed; functionality inlined in itemBuilder to access id
}
