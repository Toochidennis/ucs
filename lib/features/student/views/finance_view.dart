// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ucs/features/student/controllers/finance_controller.dart';


// class FinanceView extends GetView<FinanceController> {
//   const FinanceView({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           "Faculty Finance Office",
//           style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurface),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Obx(
//         () => SingleChildScrollView(
//           padding: const EdgeInsets.only(bottom: 90),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _StatusHeader(progress: controller.stepProgress.value, status: controller.status.value),

//               // requirements
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Required Documents", style: theme.textTheme.titleSmall),
//                     const SizedBox(height: 10),
//                     ...[
//                       ["Original school fees receipts", "For each academic year (Year 1 to Year 4)"],
//                       ["Acceptance fee receipt", "Original receipt required"],
//                       ["Handbook fee receipt", "Student handbook payment proof"],
//                       ["Fees clearance receipt", "Issued by faculty finance office"],
//                     ].map((e) => _RequirementTile(title: e[0], subtitle: e[1])),
//                   ],
//                 ),
//               ),

//               // upload cards
//               Container(
//                 color: Colors.grey[50],
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Upload Documents", style: AppFont.titleSmall),
//                     const SizedBox(height: 12),
//                     _UploadCard(
//                       title: "School Fees Receipts (4 Years)",
//                       required: true,
//                       files: controller.uploadedFiles,
//                       onUpload: controller.pickFile,
//                       onRemove: controller.removeFile,
//                     ),
//                     const SizedBox(height: 12),
//                     _UploadCard(title: "Acceptance Fee Receipt", required: true),
//                     const SizedBox(height: 12),
//                     _UploadCard(title: "Handbook Fee Receipt", required: true),
//                     const SizedBox(height: 12),
//                     _UploadCard(title: "Fees Clearance Receipt", required: true),
//                   ],
//                 ),
//               ),

//               // status
//               _ClearanceStatusSection(status: controller.status.value),
//             ],
//           ),
//         ),
//       ),

//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: controller.saveDraft,
//                 style: OutlinedButton.styleFrom(
//                   backgroundColor: Colors.grey[100],
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: Text("Save Draft", style: AppFont.bodyMedium),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: controller.submit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(AppColor.primary),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: Text("Submit for Review", style: AppFont.button.copyWith(color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: const Color(AppColor.secondary),
//         child: const Icon(Icons.help_outline, color: Colors.white),
//       ),
//     );
//   }
// }
