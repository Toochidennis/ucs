import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/add_student_controller.dart';
import 'package:ucs/features/admin/widgets/form_fields.dart';
import 'package:ucs/features/admin/widgets/form_section.dart';

class AddStudentView extends GetView<AddStudentController> {
  const AddStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(result: controller.addedAny.value),
        ),
        title: Text("Add New Student", style: AppFont.titleMedium),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: controller.submitForm,
              child: const Text("Save"),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FormSection(
                      title: "Personal Information",
                      children: [
                        InputField(
                          label: "First Name *",
                          controller: controller.firstName,
                          required: true,
                        ),
                        InputField(
                          label: "Middle Name",
                          controller: controller.middleName,
                        ),
                        InputField(
                          label: "Last Name *",
                          controller: controller.lastName,
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
                        DateField(
                          label: "Date of Birth",
                          controller: controller.dob,
                        ),
                        DropdownField(
                          label: "Gender",
                          selected: controller.gender,
                          options: const ["Male", "Female"],
                          required: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    FormSection(
                      title: "Academic Information",
                      children: [
                        InputField(
                          label: "Matric No *",
                          controller: controller.matricNo,
                          required: true,
                        ),
                        DropdownField(
                          label: "Faculty *",
                          selected: controller.faculty,
                          options: controller.faculties.keys.toList(),
                          required: true,
                        ),
                        DropdownField(
                          label: "Department *",
                          selected: controller.department,
                          options:
                              controller.departments[controller
                                  .faculty
                                  .value] ??
                              [],
                          required: true,
                        ),
                        DropdownField(
                          label: "Level *",
                          selected: controller.level,
                          options: ['400L', '500L'],
                          required: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    FormSection(
                      title: "Account Settings",
                      children: [
                        PasswordField(
                          label: "Initial Password *",
                          controller: controller.password,
                          showPassword: controller.showPassword,
                        ),
                        DropdownField(
                          label: "Status",
                          selected: controller.studentStatus,
                          options: ["Pending", "Cleared", "Suspended"],
                          required: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
