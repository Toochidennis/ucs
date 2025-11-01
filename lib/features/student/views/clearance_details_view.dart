import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/data/models/enums.dart';
import 'package:ucs/data/models/clearance_document.dart';
import 'package:ucs/features/student/controllers/clearance_details_controller.dart';
import 'package:ucs/features/student/views/pdf_preview_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ClearanceDetailsView extends GetView<ClearanceDetailsController> {
  const ClearanceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.unitName,
            style: AppFont.titleSmall.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show a spinner while loading data, otherwise render the content
        if (controller.isLoading.value) {
          return Center(
            child: SpinKitChasingDots(
              color: theme.colorScheme.primary,
              size: 36,
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // Status Banner: show only for approved, rejected, or pending
            if (controller.unitStatus.value == ClearanceStatusEnum.approved ||
                controller.unitStatus.value == ClearanceStatusEnum.rejected ||
                controller.unitStatus.value == ClearanceStatusEnum.pending)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _StatusBanner(status: controller.unitStatus.value!),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Requirements section title and list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Card(
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Requirements', style: AppFont.titleSmall),
                        const SizedBox(height: 12),
                        if (controller.requirements.isEmpty &&
                            !controller.isLoading.value)
                          Text(
                            'No requirements found',
                            style: AppFont.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Requirements list (separate to allow long lists to be efficient)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final r = controller.requirements[index];
                  return Obx(() {
                    final selectedNames =
                        (controller.selectedFiles[r.id] ?? const [])
                            .map((f) => f.name)
                            .toList();

                    return _RequirementUploadItem(
                      requirementId: r.id,
                      title: r.title,
                      description: r.description,
                      documents: controller.docsByRequirement[r.id] ?? const [],
                      selectedFileNames: selectedNames,
                      onUpload: () => controller.pickFileForRequirement(r.id),
                      onRemoveFile: (fileIndex) {
                        controller.removeFile(r.id, fileIndex);
                      },
                      onPreviewFile: (index) {
                        controller.previewFile(r.id, index);
                      },
                      onPreview: () {
                        final latest = controller.docsByRequirement[r.id];
                        final url = (latest != null && latest.isNotEmpty)
                            ? latest.first.fileUrl
                            : null;
                        if (url != null) {
                          Get.to(
                            () => const PdfPreviewView(),
                            arguments: {'url': url, 'title': latest?.first.fileName ?? 'Document'},
                          );
                        }
                      },
                    );
                  });
                }, childCount: controller.requirements.length),
              ),
            ),

            // bottom spacing for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      }),

      // Submit bar
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : (controller.canSubmit
                            ? controller.submitSelected
                            : null),
                  child: controller.isSubmitting.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: SpinKitChasingDots(
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        )
                      : Text(
                          controller.canSubmit
                              ? 'Submit for Review'
                              : 'No changes to submit',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final ClearanceStatusEnum status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    // If it's neither approved, rejected nor pending, don't show a banner
    if (status != ClearanceStatusEnum.approved &&
        status != ClearanceStatusEnum.rejected &&
        status != ClearanceStatusEnum.pending) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    Color bg;
    Color fg;
    String text;
    IconData icon;
    switch (status) {
      case ClearanceStatusEnum.approved:
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        text = 'Approved. No further action required.';
        icon = Icons.check_circle;
        break;
      case ClearanceStatusEnum.rejected:
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        text = 'Rejected. Please review feedback and re-upload.';
        icon = Icons.error_outline;
        break;
      case ClearanceStatusEnum.pending:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade700;
        text = 'Submitted. Pending officer review.';
        icon = Icons.hourglass_bottom;
        break;
      default:
        // Not reached due to early return; keep for completeness
        bg = theme.colorScheme.surface;
        fg = theme.colorScheme.onSurface;
        text = '';
        icon = Icons.info_outline;
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementUploadItem extends StatelessWidget {
  final String requirementId;
  final String title;
  final String? description;
  final List<ClearanceDocument> documents;
  final List<String> selectedFileNames;
  final VoidCallback onUpload;
  final VoidCallback onPreview;
  final void Function(int) onRemoveFile;
  final void Function(int) onPreviewFile;

  const _RequirementUploadItem({
    required this.requirementId,
    required this.title,
    required this.description,
    required this.documents,
    required this.selectedFileNames,
    required this.onUpload,
    required this.onPreview,
    required this.onRemoveFile,
    required this.onPreviewFile,
  });

  ClearanceDocument? get latest =>
      documents.isNotEmpty ? documents.first : null;
  bool get isApproved => latest?.status == ClearanceStatusEnum.approved;
  bool get isRejected => latest?.status == ClearanceStatusEnum.rejected;
  bool get isPending => latest?.status == ClearanceStatusEnum.pending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppFont.titleSmall),
                        if (description != null && description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(description!, style: AppFont.bodySmall),
                          ),
                      ],
                    ),
                  ),
                  _StatusChip(document: latest),
                ],
              ),

              const SizedBox(height: 8),

              // Officer feedback when rejected
              if (isRejected && (latest?.remark?.isNotEmpty ?? false))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    latest!.remark!,
                    style: AppFont.bodySmall.copyWith(
                      color: Colors.red.shade800,
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Selected files preview before submit
              if (selectedFileNames.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...selectedFileNames.mapIndexed((index, name) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => onPreviewFile(index),
                                  child: Text(
                                    name,
                                    style: AppFont.bodySmall.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                color: Colors.redAccent,
                                tooltip: 'Remove file',
                                onPressed: () => onRemoveFile(index),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Upload/Replace
                  ElevatedButton.icon(
                    onPressed: isApproved ? null : onUpload,
                    icon: const Icon(Icons.upload_outlined, size: 18),
                    label: Text(
                      isApproved ? 'Approved' : 'Upload PDF(s)',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  // Preview most recent existing
                  if (latest?.fileUrl != null)
                    OutlinedButton.icon(
                      onPressed: onPreview,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text(
                        'Preview latest',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                ],
              ),

              // Existing submissions list (optional)
              if (documents.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Previous submissions', style: AppFont.bodySmall),
                const SizedBox(height: 4),
                ...documents.map((d) => _ExistingDocRow(document: d)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExistingDocRow extends StatelessWidget {
  final ClearanceDocument document;
  const _ExistingDocRow({required this.document});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color chipBg;
    Color chipFg;
    String label;
    switch (document.status) {
      case ClearanceStatusEnum.approved:
        chipBg = Colors.green.shade50;
        chipFg = Colors.green.shade700;
        label = 'Approved';
        break;
      case ClearanceStatusEnum.rejected:
        chipBg = Colors.red.shade50;
        chipFg = Colors.red.shade700;
        label = 'Rejected';
        break;
      default:
        chipBg = Colors.orange.shade50;
        chipFg = Colors.orange.shade700;
        label = 'Pending';
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              document.fileName ?? 'Document',
              style: AppFont.bodySmall,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: chipFg.withValues(alpha: 0.2)),
            ),
            child: Text(label, style: AppFont.caption.copyWith(color: chipFg)),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ClearanceDocument? document;
  const _StatusChip({required this.document});

  @override
  Widget build(BuildContext context) {
    if (document == null) {
      return const SizedBox();
    }
    late Color bg;
    late Color fg;
    late String text;
    switch (document!.status) {
      case ClearanceStatusEnum.approved:
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        text = 'Approved';
        break;
      case ClearanceStatusEnum.rejected:
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        text = 'Rejected';
        break;
      default:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade700;
        text = 'Pending';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.2)),
      ),
      child: Text(text, style: AppFont.bodySmall.copyWith(color: fg)),
    );
  }
}
