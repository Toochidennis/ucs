import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final RxBool value;

  const ToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
