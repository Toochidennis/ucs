import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class WorkflowController extends GetxController {
  var units = <Map<String, dynamic>>[].obs;
  var suggestedRequirements = <String>[].obs;
  var selectedRequirements = <String>[].obs;

  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.indigo,
  ];

  final allUnitTypes = [
    "Department",
    "Library",
    "Alumni",
    "Hostel / Student Affairs",
    "Security",
    "Bursary",
    "Registrar",
    "Audit",
  ];

  void setRequirementsForUnit(String unitName) {
    switch (unitName.toLowerCase()) {
      case "department":
        suggestedRequirements.value = [
          "Online school fee receipts",
          "Bank tellers (for all years)",
          "Acceptance fee receipt",
          "Handbook fee receipt",
          "Fee clearance receipt",
          "Departmental dues receipt",
        ];
        break;
      case "library":
        suggestedRequirements.value = [
          "Library card",
          "Fee clearance receipt",
          "Letter of identification (if not registered)",
          "Fine receipt (if applicable)",
        ];
        break;
      case "alumni":
        suggestedRequirements.value = [
          "Final year school fee receipt",
          "Alumni fee payment (₦650)",
          "Alumni handbook",
          "Alumni ID card",
        ];
        break;
      case "hostel / student affairs":
        suggestedRequirements.value = [
          "Hostel clearance receipts",
          "Off-campus clearance (₦100/year)",
          "Accommodation receipts",
          "Fee clearance receipt",
        ];
        break;
      case "security":
        suggestedRequirements.value = [
          "School ID card",
          "Fee clearance receipt",
          "Accommodation clearance",
          "Library clearance",
          "Alumni ID card",
          "Off-campus clearance",
        ];
        break;
      case "bursary":
        suggestedRequirements.value = [
          "Convocation fee invoice",
          "Convocation fee teller",
          "Convocation fee receipt",
        ];
        break;
      case "registrar":
        suggestedRequirements.value = [
          "Typed formal application letter",
          "Addressed to Deputy Registrar",
        ];
        break;
      case "audit":
        suggestedRequirements.value = [
          "All clearance certificates",
          "Convocation receipt",
          "Application letter",
        ];
        break;
      default:
        suggestedRequirements.clear();
    }
  }

  IconData getIconForUnit(String unitName) {
    switch (unitName.toLowerCase()) {
      case "department":
        return Icons.school_rounded;
      case "library":
        return Icons.menu_book_rounded;
      case "alumni":
        return Icons.groups_2_rounded;
      case "hostel / student affairs":
        return Icons.house_rounded;
      case "security":
        return Icons.shield_moon_rounded;
      case "bursary":
        return Icons.receipt_long_rounded;
      case "registrar":
        return Icons.edit_document;
      case "audit":
        return Icons.check_circle_rounded;
      default:
        return Icons.business_center_rounded;
    }
  }

  void toggleRequirement(String req) {
    if (selectedRequirements.contains(req)) {
      selectedRequirements.remove(req);
    } else {
      selectedRequirements.add(req);
    }
  }

  void addUnitFromForm(
      String title, bool enabled, String instructions, IconData icon) {
    final color = _colors[units.length % _colors.length];
    final newUnit = {
      "id": const Uuid().v4(),
      "title": title,
      "enabled": enabled,
      "color": color,
      "icon": icon,
      "order": units.length + 1,
      "requirements": selectedRequirements.toList(),
      "instructions": instructions.trim(),
    };
    units.add(newUnit);

    selectedRequirements.clear();
    suggestedRequirements.clear();
  }

  void reorderUnits(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = units.removeAt(oldIndex);
    units.insert(newIndex, item);
    for (int i = 0; i < units.length; i++) {
      units[i]["order"] = i + 1;
    }
  }

  void toggleUnit(Map<String, dynamic> unit, bool val) {
    final index = units.indexOf(unit);
    if (index != -1) {
      units[index]["enabled"] = val;
      units.refresh();
    }
  }
}
