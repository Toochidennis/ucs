import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool required;
  final TextInputType type;

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    this.required = false,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
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
}

class DropdownField extends StatelessWidget {
  final String label;
  final RxString selected;
  final List<String> options;

  const DropdownField({
    super.key,
    required this.label,
    required this.selected,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
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
}

class DateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const DateField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
            context: context,
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
}

class PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final RxBool showPassword;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.showPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Obx(
        () => TextFormField(
          controller: controller,
          obscureText: !showPassword.value,
          validator: (v) =>
              (v == null || v.isEmpty) ? "Password is required" : null,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(
                showPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () => showPassword.value = !showPassword.value,
            ),
          ),
        ),
      ),
    );
  }
}
