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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add New Officer"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(result: controller.addedAny.value),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: controller.saveOfficer,
              child: const Text("Save"),
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
                        label: "Email Address",
                        controller: controller.email,
                        type: TextInputType.emailAddress,
                      ),
                      InputField(
                        label: "Phone Number",
                        controller: controller.phone,
                        type: TextInputType.phone,
                      ),
                      DropdownField(
                        label: "Gender",
                        selected: controller.gender,
                        options: const ["Male", "Female"],
                        required: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ROLE & DEPARTMENT
                  FormSection(
                    title: "Role & Unit",
                    children: [
                      Obx(
                        () => DropdownField(
                          label: "Unit *",
                          selected: controller.unit,
                          options: controller.units
                              .map((u) => u.unitName)
                              .toList(),
                          required: true,
                        ),
                      ),
                      InputField(
                        label: "Officer ID",
                        controller: controller.officerId,
                        required: true,
                      ),
                      PasswordField(
                        label: "Initial Password *",
                        controller: controller.password,
                        showPassword: controller.showPassword,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  FormSection(
                    title: "Permissions & Access",
                    children: [
                      ToggleTile(
                        title: "Review Clearance Applications",
                        subtitle:
                            "Can review and approve/reject student applications",
                        value: controller.canReview,
                      ),
                    ],
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
