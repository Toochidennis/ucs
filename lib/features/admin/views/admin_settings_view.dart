import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import '../controllers/admin_settings_controller.dart';

// ---------- VIEW ----------
class AdminSettingsView extends GetView<AdminSettingsController> {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Settings
            _settingsCard(
              "Profile Settings",
              [
                _inputField("Name", controller.name),
                _inputField("Email", controller.email),
                _inputField("Phone Number", controller.phone),
                const Divider(),
                ElevatedButton(
                  onPressed: () => _showChangePasswordDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: const Color(AppColor.primary),
                    elevation: 0,
                  ),
                  child: const Text("Change Password"),
                ),
              ],
            ),

            // School Information
            _settingsCard(
              "School Information",
              [
                _inputField("School Name", controller.schoolName),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Logo upload
                  },
                  icon: const Icon(Icons.upload, color: Colors.grey),
                  label: const Text("Upload School Logo"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
                _dropdownField("Academic Year", controller.academicYear,
                    ["2024-2025", "2025-2026", "2026-2027"]),
                _dropdownField("Semester", controller.semester,
                    ["Second Semester", "First Semester", "Summer Session"]),
              ],
            ),

            // Preferences
            _settingsCard(
              "Preferences",
              [
                _switchTile("Dark Mode", "Switch to dark theme",
                    controller.darkMode.value, (val) => controller.darkMode.value = val),
                _switchTile("Email Notifications", "Receive notifications via email",
                    controller.emailNotif.value, (val) => controller.emailNotif.value = val),
                _switchTile("In-App Notifications", "Show notifications within the app",
                    controller.inAppNotif.value, (val) => controller.inAppNotif.value = val),
              ],
            ),

            // App Info
            _settingsCard(
              "App Info & Help",
              [
                ListTile(
                  title: const Text("About"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to about page
                  },
                ),
                const Divider(),
                const ListTile(
                  title: Text("Version"),
                  trailing: Text("1.2.3"),
                ),
              ],
            ),

            // Logout
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppColor.primary),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Save Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- UI HELPERS ----------

  Widget _settingsCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppFont.titleMedium),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _dropdownField(String label, RxString selected, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: selected.value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => selected.value = val ?? "",
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: AppFont.bodyMedium),
      subtitle: Text(subtitle, style: AppFont.bodySmall),
      activeThumbColor: const Color(AppColor.primary),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(obscureText: true, decoration: InputDecoration(labelText: "Current Password")),
            TextField(obscureText: true, decoration: InputDecoration(labelText: "New Password")),
            TextField(obscureText: true, decoration: InputDecoration(labelText: "Confirm New Password")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {}, child: const Text("Save Password")),
        ],
      ),
    );
  }
}
