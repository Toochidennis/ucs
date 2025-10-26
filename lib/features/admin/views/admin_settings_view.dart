import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_settings_controller.dart';
import 'package:ucs/features/admin/widgets/toggle_tile.dart';

class AdminSettingsView extends GetView<AdminSettingsController> {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(
        () => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _settingsCard(context, "Profile Settings", [
                    _inputField(
                      "Name",
                      controller.nameCtrl,
                      scheme,
                      readOnly: true,
                    ),
                    _inputField(
                      "Email",
                      controller.emailCtrl,
                      scheme,
                      readOnly: true,
                    ),
                    _inputField(
                      "Phone Number",
                      controller.phoneCtrl,
                      scheme,
                      readOnly: true,
                    ),
                    const Divider(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.resetMyPassword(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: scheme.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.lock_outline),
                      label: const Text("Change Password"),
                    ),
                  ]),

                  _settingsCard(context, "School Information", [
                    // Logo preview
                    Obx(() {
                      final url = controller.logoUrl.value;
                      if (url.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      );
                    }),
                    _inputField(
                      "School Name",
                      controller.schoolNameCtrl,
                      scheme,
                    ),
                    _inputField("Session", controller.sessionCtrl, scheme),
                    _inputField("Semester", controller.semesterCtrl, scheme),
                    _dateField(
                      context,
                      label: 'Clearance Deadline',
                      dateRx: controller.clearanceDeadline,
                      onPick: () => controller.pickDeadline(context),
                      scheme: scheme,
                    ),
                    const SizedBox(height: 4),
                    _inputField(
                      "Contact Email",
                      controller.contactEmailCtrl,
                      scheme,
                    ),
                    _inputField(
                      "Contact Phone",
                      controller.contactPhoneCtrl,
                      scheme,
                    ),
                    OutlinedButton.icon(
                      onPressed: controller.pickAndUploadLogo,
                      icon: Icon(Icons.upload_outlined, color: scheme.primary),
                      label: Text(
                        "Upload School Logo",
                        style: TextStyle(color: scheme.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: scheme.primary, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ]),

                  _settingsCard(context, "Preferences", [
                    ToggleTile(
                      title: "Auto-approve on document upload",
                      subtitle:
                          "Automatically approve when all documents are uploaded",
                      value: controller.autoApprove,
                    ),
                  ]),

                  _settingsCard(context, "App Info & Help", [
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: const Text("About"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                    const Divider(height: 0),
                    Obx(
                      () => ListTile(
                        title: const Text("Version"),
                        trailing: Text(controller.appVersion.value),
                      ),
                    ),
                  ]),

                  // LOGOUT CARD
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1.5,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: controller.logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                      ),
                    ),
                  ),

                  // SAVE SETTINGS
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save Settings",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFont.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    ColorScheme scheme, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _dateField(
    BuildContext context, {
    required String label,
    required Rxn<DateTime> dateRx,
    required VoidCallback onPick,
    required ColorScheme scheme,
  }) {
    final formatted = Obx(() {
      final d = dateRx.value;
      final text = d == null ? '' : DateFormat.yMMMMd().format(d);
      return TextFormField(
        readOnly: true,
        onTap: onPick,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Tap to pick a date',
          suffixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.primary, width: 1.2),
          ),
        ),
        controller: TextEditingController(text: text),
      );
    });
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: formatted,
    );
  }
}
