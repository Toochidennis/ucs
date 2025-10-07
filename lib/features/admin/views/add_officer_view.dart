import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/officer_controller.dart';

class AddOfficerView extends GetView<OfficerController> {
  const AddOfficerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Add New Officer"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📸 Profile Photo
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.camera_alt,
                          size: 40, color: Colors.grey),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 🧑 Personal Info
              _buildSection("Personal Information", [
                _inputField("Full Name *", controller.fullName, required: true),
                _inputField("Email Address *", controller.email,
                    type: TextInputType.emailAddress, required: true),
                _inputField("Phone Number", controller.phone,
                    type: TextInputType.phone),
              ]),

              const SizedBox(height: 16),

              // 🏢 Role & Department
              _buildSection("Role & Department", [
                Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: controller.department.value.isEmpty
                        ? null
                        : controller.department.value,
                    items: [
                      "Finance Office",
                      "Library",
                      "Hostel Management",
                      "Alumni Office",
                      "Registry",
                      "Security",
                      "ICT Department"
                    ]
                        .map((dept) => DropdownMenuItem(
                              value: dept,
                              child: Text(dept),
                            ))
                        .toList(),
                    onChanged: (val) => controller.department.value = val ?? "",
                    decoration: const InputDecoration(
                      labelText: "Department *",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        (val == null || val.isEmpty) ? "Select a department" : null,
                  ),
                ),
                _inputField("Role/Position *", controller.role, required: true),
                _inputField("Employee ID", controller.employeeId),
              ]),

              const SizedBox(height: 16),

              // 🔐 Permissions
              _buildSection("Permissions & Access", [
                _toggleTile("Review Clearance Applications",
                    "Can review and approve/reject student applications",
                    controller.canReview),
                _toggleTile("Manage Documents",
                    "Can upload, download, and manage documents",
                    controller.canManageDocs),
                _toggleTile("Send Notifications",
                    "Can send notifications to students",
                    controller.canSendNotif),
                _toggleTile("Generate Reports",
                    "Can generate and export reports",
                    controller.canGenerateReports),
              ]),

              const SizedBox(height: 16),

              // ⚙️ Additional Settings
              _buildSection("Additional Settings", [
                _toggleTile("Officer Status", "Set initial status for this officer",
                    controller.officerStatus),
                _toggleTile("Email Notifications",
                    "Receive email notifications for new applications",
                    controller.emailNotif),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => ListTile(
                          title: const Text("Start Time"),
                          subtitle: Text(controller.startTime.value.format(context)),
                          trailing: const Icon(Icons.access_time),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: controller.startTime.value,
                            );
                            if (picked != null) {
                              controller.startTime.value = picked;
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => ListTile(
                          title: const Text("End Time"),
                          subtitle: Text(controller.endTime.value.format(context)),
                          trailing: const Icon(Icons.access_time),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: controller.endTime.value,
                            );
                            if (picked != null) {
                              controller.endTime.value = picked;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 24),

              // 🚀 Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveOfficer,
                  child: const Text("Save Officer"),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====== UI Helpers ======
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {bool required = false, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: required
            ? (v) =>
                (v == null || v.trim().isEmpty) ? "$label is required" : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _toggleTile(String title, String subtitle, RxBool value) {
    return Obx(
      () => SwitchListTile(
        value: value.value,
        onChanged: (v) => value.value = v,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        activeThumbColor: Colors.blue,
      ),
    );
  }
}
