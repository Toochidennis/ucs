import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/core/constants/app_font.dart';
import '../controllers/student_controller.dart';

class AddStudentView extends GetView<StudentController> {
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
                // 📌 Personal Info
                _buildSection("Personal Information", [
                  _inputField("First Name *", controller.firstName, required: true),
                  _inputField("Middle Name", controller.middleName),
                  _inputField("Last Name *", controller.lastName, required: true),
                  _inputField("Email Address *", controller.email,
                      required: true, type: TextInputType.emailAddress),
                  _inputField("Phone Number *", controller.phone,
                      required: true, type: TextInputType.phone),
                  _dateField("Date of Birth", controller.dob),
                  _genderSelector(),
                ]),

                const SizedBox(height: 20),

                // 📌 Academic Info
                _buildSection("Academic Information", [
                  _inputField("Student ID *", controller.studentId, required: true),
                  _dropdownField("Program/Course *", controller.program, [
                    "Bachelor's Degree",
                    "Master's Degree",
                    "PhD",
                    "Certificate Program"
                  ]),
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

                // 📌 Faculty & Dept
                _buildSection("Faculty and Department Assignment", [
                  _dropdownField("Faculty *", controller.faculty,
                      controller.faculties.keys.toList()),
                  _dropdownField(
                    "Department *",
                    controller.department,
                    controller.departments[controller.faculty.value] ?? [],
                  ),
                  _inputField("Academic Advisor", controller.advisor),
                ]),

                const SizedBox(height: 20),

                // 📌 Contact Info
                _buildSection("Contact Information", [
                  _inputField("Street Address", controller.street),
                  Row(
                    children: [
                      Expanded(child: _inputField("City", controller.city)),
                      const SizedBox(width: 10),
                      Expanded(child: _inputField("State", controller.state)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _inputField("Postal Code", controller.postal)),
                      const SizedBox(width: 10),
                      Expanded(child: _inputField("Country", controller.country)),
                    ],
                  ),
                  _inputField("Emergency Contact Name", controller.emergencyName),
                  Row(
                    children: [
                      Expanded(child: _inputField("Relationship", controller.relationship)),
                      const SizedBox(width: 10),
                      Expanded(child: _inputField("Phone", controller.emergencyPhone)),
                    ],
                  ),
                ]),

                const SizedBox(height: 20),

                // 📌 Account Settings
                _buildSection("Account Settings", [
                  _passwordField("Initial Password *", controller.password),
                  _dropdownField(
                      "Account Status", controller.accountStatus, ["Active", "Inactive"]),
                  SwitchListTile(
                    value: controller.portalAccess.value,
                    onChanged: (v) => controller.portalAccess.value = v,
                    activeColor: const Color(AppColor.primary),
                    title: Text("Enable Student Portal Access",
                        style: AppFont.bodySmall),
                  ),
                  _dateField("Account Activation Date", controller.activationDate),
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

  // ========== UI Helpers ==========

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
            ? (v) => (v == null || v.trim().isEmpty) ? "$label is required" : null
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
          value: selected.value.isEmpty ? null : selected.value,
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
          obscureText: !Get.find<StudentController>().showPassword.value,
          validator: (v) =>
              (v == null || v.isEmpty) ? "Password is required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(
                Get.find<StudentController>().showPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                Get.find<StudentController>().showPassword.value =
                    !Get.find<StudentController>().showPassword.value;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender", style: AppFont.bodySmall),
        Obx(() => Row(
              children: [
                _radioOption("Male", "male"),
                _radioOption("Female", "female"),
                _radioOption("Other", "other"),
              ],
            )),
      ],
    );
  }

  Widget _radioOption(String label, String value) {
    return Row(
      children: [
        Obx(
          () => Radio<String>(
            value: value,
            groupValue: controller.gender.value,
            onChanged: (val) => controller.gender.value = val ?? "",
          ),
        ),
        Text(label),
      ],
    );
  }
}
