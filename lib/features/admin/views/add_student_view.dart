import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/add_student_controller.dart';
import 'package:ucs/features/admin/widgets/form_fields.dart';
import 'package:ucs/features/admin/widgets/form_section.dart';
import 'package:ucs/features/admin/widgets/toggle_tile.dart';

class AddStudentView extends GetView<AddStudentController> {
  const AddStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text("Add New Student", style: AppFont.titleMedium),
          ],
        ),
        centerTitle: true,
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
                    // PERSONAL INFORMATION
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
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ACADEMIC INFORMATION
                    FormSection(
                      title: "Academic Information",
                      children: [
                        InputField(
                          label: "Matric No *",
                          controller: controller.studentId,
                          required: true,
                        ),
                        InputField(
                          label: "Major / Field of Study",
                          controller: controller.major,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // FACULTY AND DEPARTMENT
                    FormSection(
                      title: "Faculty and Department Assignment",
                      children: [
                        DropdownField(
                          label: "Faculty *",
                          selected: controller.faculty,
                          options: controller.faculties.keys.toList(),
                        ),
                        DropdownField(
                          label: "Department *",
                          selected: controller.department,
                          options: controller
                                  .departments[controller.faculty.value] ??
                              [],
                        ),
                        InputField(
                          label: "Academic Advisor",
                          controller: controller.advisor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ACCOUNT SETTINGS
                    FormSection(
                      title: "Account Settings",
                      children: [
                        PasswordField(
                          label: "Initial Password *",
                          controller: controller.password,
                          showPassword: controller.showPassword,
                        ),
                        ToggleTile(
                          title: "Student Status",
                          subtitle: "Enable/disable student account",
                          value: controller.studentStatus,
                        ),
                        ToggleTile(
                          title: "Send Login Details via Email",
                          subtitle:
                              "Automatically send login credentials to student",
                          value: controller.studentStatus,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isFormValid.value
                                ? controller.submitForm
                                : null,
                            child: const Text("Add Student"),
                          ),
                        ),
                      ],
                    ),
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
