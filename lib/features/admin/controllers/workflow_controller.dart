import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:ucs/core/constants/app_color.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchUnitsFromDB();
  }

  /// Load from DB or Prefill if Empty
  Future<void> fetchUnitsFromDB() async {
    // TODO: replace this mock check with actual DB fetch
    if (units.isEmpty) {
      loadPrefilledUnits();
    }
  }

  /// Prefilled Default UNN Clearance Units
  void loadPrefilledUnits() {
    final defaults = [
      {
        "title": "Faculty Finance Office",
        "requirements": [
          "Online school fees receipts (all sessions)",
          "Bank tellers",
          "Acceptance fee receipt",
          "Faculty handbook receipt",
          "Fees clearance receipt",
          "Convocation fee invoice, teller, and receipt"
        ],
        "instructions":
            "Upload clear copies of all your school fees receipts, bank tellers, acceptance and handbook receipts for review by the Faculty Finance Office. Once verified, your fees clearance certificate will be approved. If any document is missing or unclear, visit the office in person. You may also upload your convocation fee documents here.",
      },
      {
        "title": "Library",
        "requirements": [
          "Library registration card",
          "Letter of identification from HOD (if not registered)",
          "Payment receipt (if card is lost)"
        ],
        "instructions":
            "Upload a scanned copy of your library card or proof of registration. If you were never registered, upload a letter of identification from your HOD. If your card was lost, upload the payment receipt for its replacement. Visit the Library only for registration or replacement.",
      },
      {
        "title": "Alumni Office",
        "requirements": [
          "Final year school fees receipt",
          "₦650 Alumni payment receipt",
          "Alumni handbook",
          "Alumni ID card"
        ],
        "instructions":
            "Upload proof of your Alumni payment, handbook, and Alumni ID card for verification. If unpaid, visit the Alumni Office to make payment and collect your materials before completing this section online.",
      },
      {
        "title": "Students' Affairs Department",
        "requirements": [
          "Hostel accommodation receipts (per year stayed)",
          "Accommodation clearance receipts",
          "Off-campus clearance receipts (₦100/year)"
        ],
        "instructions":
            "Upload your hostel receipts or accommodation clearance documents. If you stayed off campus, upload your off-campus clearance receipts instead. Visit the Students’ Affairs Department (Clearance Room) if receipts are missing or need verification.",
      },
      {
        "title": "Security Department",
        "requirements": [
          "₦150 security clearance payment receipt",
          "School ID card",
          "Verified clearance certificates (Finance, Library, Accommodation, Alumni)"
        ],
        "instructions":
            "Upload your school ID card and verified clearances. Once your records are reviewed, a digital security clearance will be issued. If you have pending security files or unresolved issues, visit the Security Department for manual processing.",
      },
      {
        "title": "Registrar’s Office",
        "requirements": [
          "Typed formal application letter",
          "School fees clearance certificate"
        ],
        "instructions":
            "Upload a typed and signed letter titled ‘Application for the Collection of My Statement of Results and Original Degree Certificate’, addressed to the Deputy Registrar, UNN. Upload it with your fees clearance certificate. Visit the Registrar’s Office only if clarification is required.",
      },
      {
        "title": "Audit Unit",
        "requirements": [
          "All verified clearance certificates",
          "Application letter",
          "Convocation fee receipts"
        ],
        "instructions":
            "Arrange all verified clearance documents in order and upload them to the Audit Unit section. Once verified, you will receive your final clearance approval. Visit the Audit Unit only if inconsistencies occur.",
      },
      {
        "title": "Department / Faculty Dues Office",
        "requirements": [
          "Departmental dues receipts (all sessions)",
          "Faculty dues receipts"
        ],
        "instructions":
            "Upload all departmental and faculty dues receipts. If any payment record is missing, visit the Department or Faculty Office to complete payment before clearance can proceed.",
      }
    ];

    for (int i = 0; i < defaults.length; i++) {
      units.add({
        "id": const Uuid().v4(),
        "title": defaults[i]["title"],
        "requirements": defaults[i]["requirements"],
        "instructions": defaults[i]["instructions"],
        "enabled": true,
        "is_default": true,
        "can_delete": false,
        "order": i + 1,
        "color": _colors[i % _colors.length],
        "icon": getIconForUnit(defaults[i]["title"]),
      });
    }
  }

  /// Add New Custom Unit
  void addUnitFromForm(
      String title, bool enabled, String instructions, IconData icon) {
    final color = _colors[units.length % _colors.length];
    final newUnit = {
      "id": const Uuid().v4(),
      "title": title.trim(),
      "enabled": enabled,
      "color": color,
      "icon": icon,
      "is_default": false,
      "can_delete": true,
      "order": units.length + 1,
      "requirements": selectedRequirements.toList(),
      "instructions": instructions.trim(),
    };
    units.add(newUnit);
    selectedRequirements.clear();
    suggestedRequirements.clear();
    saveUnitsToDB();
  }

  void toggleUnit(Map<String, dynamic> unit, bool val) {
    final index = units.indexOf(unit);
    if (index != -1) {
      units[index]["enabled"] = val;
      units.refresh();
      saveUnitsToDB();
    }
  }

  // Inside WorkflowController
void toggleRequirement(String req) {
  if (selectedRequirements.contains(req)) {
    selectedRequirements.remove(req);
  } else {
    selectedRequirements.add(req);
  }
}


  void reorderUnits(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = units.removeAt(oldIndex);
    units.insert(newIndex, item);
    for (int i = 0; i < units.length; i++) {
      units[i]["order"] = i + 1;
    }
    saveUnitsToDB();
  }

  IconData getIconForUnit(String name) {
    name = name.toLowerCase();
    if (name.contains("finance")) return Icons.receipt_long_rounded;
    if (name.contains("library")) return Icons.menu_book_rounded;
    if (name.contains("alumni")) return Icons.groups_2_rounded;
    if (name.contains("student") || name.contains("hostel"))
      return Icons.house_rounded;
    if (name.contains("security")) return Icons.shield_rounded;
    if (name.contains("registrar")) return Icons.edit_document;
    if (name.contains("audit")) return Icons.check_circle_rounded;
    if (name.contains("dues")) return Icons.school_rounded;
    return Icons.business_rounded;
  }

  Future<void> saveUnitsToDB() async {
    // TODO: Connect to backend or local DB (Appwrite or SQLite)
    // e.g., await Database.save('clearance_units', units);
  }
}
