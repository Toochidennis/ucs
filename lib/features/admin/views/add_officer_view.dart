import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/admin/controllers/add_officer_controller.dart';
import 'package:ucs/features/admin/widgets/form_fields.dart';
import 'package:ucs/features/admin/widgets/form_section.dart';
import 'package:ucs/features/admin/widgets/toggle_tile.dart';

class AddOfficerView extends GetView<AddOfficerController> {
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
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // PERSONAL INFORMATION
                  FormSection(
                    title: "Personal Information",
                    children: [
                      InputField(
                        label: "Full Name *",
                        controller: controller.fullName,
                        required: true,
                      ),
                      InputField(
                        label: "Email Address *",
                        controller: controller.email,
                        type: TextInputType.emailAddress,
                        required: true,
                      ),
                      InputField(
                        label: "Phone Number",
                        controller: controller.phone,
                        type: TextInputType.phone,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ROLE & DEPARTMENT
                  FormSection(
                    title: "Role & Department",
                    children: [
                      DropdownField(
                        label: "Department *",
                        selected: controller.department,
                        options: const [
                          "Finance Office",
                          "Library",
                          "Hostel Management",
                          "Alumni Office",
                          "Registry",
                          "Security",
                          "ICT Department",
                        ],
                      ),
                      InputField(
                        label: "Employee ID",
                        controller: controller.employeeId,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // PERMISSIONS & ACCESS
                  FormSection(
                    title: "Permissions & Access",
                    children: [
                      PasswordField(
                        label: "Initial Password *",
                        controller: controller.password,
                        showPassword: controller.showPassword,
                      ),
                      ToggleTile(
                        title: "Review Clearance Applications",
                        subtitle:
                            "Can review and approve/reject student applications",
                        value: controller.canReview,
                      ),
                      ToggleTile(
                        title: "Officer Status",
                        subtitle: "Enable/disable officer account",
                        value: controller.officerStatus,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

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
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
