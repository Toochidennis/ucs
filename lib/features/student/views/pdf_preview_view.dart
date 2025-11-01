import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewView extends StatefulWidget {
  const PdfPreviewView({super.key});

  @override
  State<PdfPreviewView> createState() => _PdfPreviewViewState();
}

class _PdfPreviewViewState extends State<PdfPreviewView> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int totalPages = 0;
  int currentPage = 1;
  bool isLoading = true;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final url = args?['url'] as String?;
    final title = args?['title'] as String? ?? 'PDF Preview';

    if (url == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No PDF URL provided')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (totalPages > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$currentPage / $totalPages',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              _pdfViewerController.zoomLevel =
                  _pdfViewerController.zoomLevel + 0.25;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            url,
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                totalPages = details.document.pages.count;
                isLoading = false;
              });
            },
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                currentPage = details.newPageNumber;
              });
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${details.error}'),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                    },
                  ),
                ),
              );
              setState(() {
                isLoading = false;
              });
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            onPressed: () {
              _pdfViewerController.zoomLevel =
                  _pdfViewerController.zoomLevel - 0.25;
            },
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'first_page',
            mini: true,
            onPressed: () {
              _pdfViewerController.jumpToPage(1);
            },
            child: const Icon(Icons.first_page),
          ),
        ],
      ),
    );
  }
}
