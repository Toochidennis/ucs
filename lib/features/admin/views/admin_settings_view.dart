import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/admin_settings_controller.dart';
import 'package:ucs/features/admin/widgets/toggle_tile.dart';

class AdminSettingsView extends GetView<AdminSettingsController> {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _settingsCard(
                    context,
                    "Profile Settings",
                    [
                      _inputField("Name", controller.name),
                      _inputField("Email", controller.email),
                      _inputField("Phone Number", controller.phone),
                      const Divider(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showChangePasswordDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: const Color(AppColor.primary),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.lock_outline),
                        label: const Text("Change Password"),
                      ),
                    ],
                  ),

                  _settingsCard(
                    context,
                    "School Information",
                    [
                      _inputField("School Name", controller.schoolName),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload_outlined,
                            color: Color(AppColor.primary)),
                        label: const Text(
                          "Upload School Logo",
                          style:
                              TextStyle(color: Color(AppColor.primary)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(AppColor.primary),
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  _settingsCard(
                    context,
                    "Preferences",
                    [
                      ToggleTile(
                        title: "Auto-approve on document upload",
                        subtitle:
                            "Automatically approve when all documents are uploaded",
                        value: controller.autoApprove,
                      ),
                      _switchTile(
                        "Dark Mode",
                        "Switch to dark theme",
                        controller.darkMode.value,
                        (val) => controller.darkMode.value = val,
                      ),
                      _switchTile(
                        "Email Notifications",
                        "Receive notifications via email",
                        controller.emailNotif.value,
                        (val) => controller.emailNotif.value = val,
                      ),
                      _switchTile(
                        "In-App Notifications",
                        "Show notifications within the app",
                        controller.inAppNotif.value,
                        (val) => controller.inAppNotif.value = val,
                      ),
                    ],
                  ),

                  _settingsCard(
                    context,
                    "App Info & Help",
                    [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text("About"),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                      const Divider(height: 0),
                      const ListTile(
                        title: Text("Version"),
                        trailing: Text("1.2.3"),
                      ),
                    ],
                  ),

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
                        backgroundColor: const Color(AppColor.primary),
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

  Widget _settingsCard(BuildContext context, String title, List<Widget> children) {
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

  Widget _inputField(String label, RxString value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value.value,
        onChanged: (val) => value.value = val,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(AppColor.primary), width: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: AppFont.bodyMedium),
      subtitle: Text(subtitle, style: AppFont.bodySmall),
      activeTrackColor: const Color(AppColor.primary).withOpacity(0.3),
      activeColor: const Color(AppColor.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Current Password"),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirm New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppColor.primary),
            ),
            child: const Text("Save Password"),
          ),
        ],
      ),
    );
  }
}
