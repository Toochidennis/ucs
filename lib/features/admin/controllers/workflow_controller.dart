import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkflowController extends GetxController {
  var units = <Map<String, dynamic>>[
    {
      "icon": Icons.account_balance,
      "title": "Finance Office",
      "subtitle": "Priority: High",
      "enabled": true,
      "color": Colors.blue,
    },
    {
      "icon": Icons.book,
      "title": "Library",
      "subtitle": "Priority: Medium",
      "enabled": true,
      "color": Colors.green,
    },
  ].obs;

  var autoApprove = false.obs;
  var emailNotifications = true.obs;
  var deadlineReminders = true.obs;

  void addUnit() {
    // TODO: implement add logic
  }

  void toggleUnit(Map<String, dynamic> unit, bool value) {
    unit["enabled"] = value;
    units.refresh();
  }

  void toggleAutoApprove(bool value) => autoApprove.value = value;
  void toggleEmailNotifications(bool value) => emailNotifications.value = value;
  void toggleDeadlineReminders(bool value) => deadlineReminders.value = value;
}
