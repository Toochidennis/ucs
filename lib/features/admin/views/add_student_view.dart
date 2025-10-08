import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/admin/controllers/add_student_controller.dart';

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
            Text("Create student account", style: AppFont.caption),
          ],
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                _buildSection("Personal Information", [
                  _inputField(
                    "First Name *",
                    controller.firstName,
                    required: true,
                  ),
                  _inputField("Middle Name", controller.middleName),
                  _inputField(
                    "Last Name *",
                    controller.lastName,
                    required: true,
                  ),
                  _inputField(
                    "Email Address ",
                    controller.email,
                    type: TextInputType.emailAddress,
                  ),
                  _inputField(
                    "Phone Number",
                    controller.phone,
                    type: TextInputType.phone,
                  ),
                  _dateField("Date of Birth", controller.dob),
                  _dropdownField("Gender", controller.gender, [
                    "Male",
                    "Female",
                  ]),
                ]),

                const SizedBox(height: 20),

                _buildSection("Academic Information", [
                  _inputField(
                    "Matric No *",
                    controller.studentId,
                    required: true,
                  ),
                  _inputField("Major/Field of Study", controller.major),
                  Row(
                    children: [
                      Expanded(
                        child: _inputField(
                          "Enrollment Year",
                          controller.enrollmentYear,
                          type: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _inputField(
                          "Expected Graduation",
                          controller.graduationYear,
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ]),

                const SizedBox(height: 20),

                _buildSection("Faculty and Department Assignment", [
                  _dropdownField(
                    "Faculty *",
                    controller.faculty,
                    controller.faculties.keys.toList(),
                  ),
                  _dropdownField(
                    "Department *",
                    controller.department,
                    controller.departments[controller.faculty.value] ?? [],
                  ),
                  _inputField("Academic Advisor", controller.advisor),
                ]),

                const SizedBox(height: 20),

                _buildSection("Account Settings", [
                  _passwordField("Initial Password *", controller.password),
                  _dropdownField("Account Status", controller.accountStatus, [
                    "Active",
                    "Inactive",
                  ]),
                ]),

                const SizedBox(height: 24),

                // Buttons
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
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

  Widget _inputField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType type = TextInputType.text,
  }) {
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

  Widget _dropdownField(String label, RxString selected, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Obx(
        () => DropdownButtonFormField<String>(
          initialValue: selected.value.isEmpty ? null : selected.value,
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => selected.value = val ?? "",
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _dateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1980),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.text = "${picked.toLocal()}".split(" ")[0];
          }
        },
      ),
    );
  }

  Widget _passwordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Obx(
        () => TextFormField(
          controller: controller,
          obscureText: !Get.find<AddStudentController>().showPassword.value,
          validator: (v) =>
              (v == null || v.isEmpty) ? "Password is required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(
                Get.find<AddStudentController>().showPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                Get.find<AddStudentController>().showPassword.value =
                    !Get.find<AddStudentController>().showPassword.value;
              },
            ),
          ),
        ),
      ),
    );
  }
}
