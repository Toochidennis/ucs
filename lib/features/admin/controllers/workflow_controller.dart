import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class WorkflowController extends GetxController {
  var units = <Map<String, dynamic>>[].obs;
  var suggestedRequirements = <String>[].obs;

  final List<String> allUnitTypes = [
    "Faculty Finance Office",
    "Library",
    "Alumni Office",
    "Students’ Affairs Department",
    "Security Department",
    "Registrar’s Office",
    "Audit Unit",
    "Department / Faculty Dues Office",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchUnitsFromDB();
  }

  Future<void> fetchUnitsFromDB() async {
    if (units.isEmpty) loadPrefilledUnits();
  }

  void loadPrefilledUnits() {
    final defaults = [
      {
        "title": "Bursary Unit",
        "requirements": [
          "Online school fees receipts (all sessions)",
          "Bank tellers",
          "Acceptance fee receipt",
          "Faculty handbook receipt",
          "Fees clearance receipt",
          "Convocation fee invoice, teller, and receipt",
        ],
        "instructions":
            "Upload clear copies of all your school fees receipts, bank tellers, acceptance and handbook receipts for review by the Faculty Finance Office. Once verified, your fees clearance certificate will be approved. If any document is missing or unclear, visit the office in person. You may also upload your convocation fee documents here.",
      },
      {
        "title": "Library Unit",
        "requirements": [
          "Library registration card",
          "Letter of identification from HOD (if not registered)",
          "Payment receipt (if card is lost)",
        ],
        "instructions":
            "Upload a scanned copy of your library card or proof of registration. If you were never registered, upload a letter of identification from your HOD. If your card was lost, upload the payment receipt for its replacement. Visit the Library only for registration or replacement.",
      },
      {
        "title": "Alumni Unit",
        "requirements": [
          "Final year school fees receipt",
          "₦650 Alumni payment receipt",
          "Alumni handbook",
          "Alumni ID card",
        ],
        "instructions":
            "Upload proof of your Alumni payment, handbook, and Alumni ID card for verification. If unpaid, visit the Alumni Office to make payment and collect your materials before completing this section online.",
      },
      {
        "title": "Students' Affairs Unit",
        "requirements": [
          "Hostel accommodation receipts (per year stayed)",
          "Accommodation clearance receipts",
          "Off-campus clearance receipts (₦100/year)",
        ],
        "instructions":
            "Upload your hostel receipts or accommodation clearance documents. If you stayed off campus, upload your off-campus clearance receipts instead. Visit the Students’ Affairs Department (Clearance Room) if receipts are missing or need verification.",
      },
      {
        "title": "Security",
        "requirements": [
          "₦150 security clearance payment receipt",
          "School ID card",
          "Verified clearance certificates (Finance, Library, Accommodation, Alumni)",
        ],
        "instructions":
            "Upload your school ID card and verified clearances. Once your records are reviewed, a digital security clearance will be issued. If you have pending security files or unresolved issues, visit the Security Department for manual processing.",
      },
      {
        "title": "Registrar's Unit",
        "requirements": [
          "Typed formal application letter",
          "School fees clearance certificate",
        ],
        "instructions":
            "Upload a typed and signed letter titled 'Application for the Collection of My Statement of Results and Original Degree Certificate’, addressed to the Deputy Registrar, UNN. Upload it with your fees clearance certificate. Visit the Registrar’s Office only if clarification is required.",
      },
      {
        "title": "Audit Unit",
        "requirements": [
          "All verified clearance certificates",
          "Application letter",
          "Convocation fee receipts",
        ],
        "instructions":
            "Arrange all verified clearance documents in order and upload them to the Audit Unit section. Once verified, you will receive your final clearance approval. Visit the Audit Unit only if inconsistencies occur.",
      },
      {
        "title": "Department Unit",
        "requirements": [
          "Departmental dues receipts (all sessions)",
          "Faculty dues receipts",
        ],
        "instructions":
            "Upload all departmental and faculty dues receipts. If any payment record is missing, visit the Department or Faculty Office to complete payment before clearance can proceed.",
      },
    ];

    for (int i = 0; i < defaults.length; i++) {
      final title = defaults[i]["title"] as String;
      units.add({
        "id": const Uuid().v4(),
        "title": title,
        "requirements": defaults[i]["requirements"],
        "instructions": defaults[i]["instructions"],
        "enabled": true,
        "order": i + 1,
        "icon_key": getIconKeyForUnit(title),
      });
    }
  }

  void setRequirementsForUnit(String unitName) {
    final match = units.firstWhereOrNull(
      (u) => u["title"].toString().toLowerCase() == unitName.toLowerCase(),
    );
    suggestedRequirements.value = match != null
        ? List<String>.from(match["requirements"])
        : [];
  }

  void toggleUnit(Map<String, dynamic> unit, bool val) {
    final index = units.indexOf(unit);
    if (index != -1) {
      units[index]["enabled"] = val;
      units.refresh();
      saveUnitsToDB();
    }
  }

  void updateInstructions(Map<String, dynamic> unit, String newText) {
    final index = units.indexOf(unit);
    if (index != -1) {
      units[index]["instructions"] = newText.trim();
      units.refresh();
      saveUnitsToDB();
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

  String getIconKeyForUnit(String name) {
    final n = name.toLowerCase();
    if (n.contains("finance")) return "finance";
    if (n.contains("library")) return "library";
    if (n.contains("alumni")) return "alumni";
    if (n.contains("student") || n.contains("hostel")) {
      return "students_affairs";
    }
    if (n.contains("security")) return "security";
    if (n.contains("registrar")) return "registrar";
    if (n.contains("audit")) return "audit";
    if (n.contains("dues")) return "dues";
    return "default";
  }

  IconData iconFromKey(String key) {
    switch (key) {
      case "finance":
        return Icons.receipt_long_rounded;
      case "library":
        return Icons.menu_book_rounded;
      case "alumni":
        return Icons.groups_2_rounded;
      case "students_affairs":
        return Icons.house_rounded;
      case "security":
        return Icons.shield_rounded;
      case "registrar":
        return Icons.edit_document;
      case "audit":
        return Icons.check_circle_rounded;
      case "dues":
        return Icons.school_rounded;
      default:
        return Icons.business_rounded;
    }
  } 

  Future<void> saveUnitsToDB() async {
    // TODO: persist to Appwrite/SQLite
  }
}
