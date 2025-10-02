import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import '../controllers/clearance_controller.dart';

class ClearanceDetailView extends GetView<ClearanceController> {
  const ClearanceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.grey, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Library Clearance", style: AppFont.titleSmall),
                        Text("Pending Review", style: AppFont.warning),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Status Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  border: Border.all(color: Colors.yellow.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.yellow.shade100,
                      radius: 16,
                      child: const Icon(Icons.access_time,
                          color: Colors.orange, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Under Review",
                              style: AppFont.bodyMedium
                                  .copyWith(color: Colors.orange.shade800)),
                          Text(
                            "Your documents are being reviewed by the library officer",
                            style: AppFont.bodySmall
                                .copyWith(color: Colors.orange.shade700),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Requirements
            _sectionCard(
              title: "Requirements",
              children: [
                _requirementItem("Return all borrowed books"),
                _requirementItem("Clear all outstanding fines"),
                _requirementItem("Submit library clearance form"),
              ],
            ),

            // Document Upload
            _sectionCard(
              title: "Upload Documents",
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.cloud_upload_outlined,
                            color: Colors.grey, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Text("Upload your clearance documents",
                          style: AppFont.bodySmall),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Choose Files"),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(120, 40),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Take Photo"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Uploaded Files
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 16,
                        child: const Icon(Icons.description,
                            color: Colors.blue, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("library_clearance_form.pdf",
                                style: AppFont.bodyMedium
                                    .copyWith(fontWeight: FontWeight.w600)),
                            Text("2.3 MB", style: AppFont.caption),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 20),
                      )
                    ],
                  ),
                )
              ],
            ),

            // Officer Feedback
            _sectionCard(
              title: "Officer Feedback",
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 18,
                        child: const Icon(Icons.person,
                            color: Colors.blue, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Dr. Michael Thompson",
                                style: AppFont.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900)),
                            Text("Library Officer",
                                style: AppFont.bodySmall
                                    .copyWith(color: Colors.blue.shade800)),
                            const SizedBox(height: 4),
                            Text(
                              "Your documents have been received and are currently under review. Please ensure all library books are returned before final approval.",
                              style: AppFont.bodySmall
                                  .copyWith(color: Colors.blue.shade700),
                            ),
                            const SizedBox(height: 4),
                            Text("2 hours ago",
                                style: AppFont.caption
                                    .copyWith(color: Colors.blue.shade600)),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

            // Disabled Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.grey.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Waiting for Officer Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Card Reusable Widget
  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppFont.titleSmall),
                const SizedBox(height: 12),
                ...children,
              ]),
        ),
      ),
    );
  }

  // Requirement Item
  Widget _requirementItem(String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.check, color: Colors.green, size: 14),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppFont.bodySmall)),
      ],
    );
  }
}
