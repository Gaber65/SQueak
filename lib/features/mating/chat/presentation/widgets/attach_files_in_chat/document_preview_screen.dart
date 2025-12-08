import 'dart:io';
import 'package:flutter/material.dart';
import 'package:squeak/generated/l10n.dart';
import 'package:path/path.dart' as path;

class DocumentPreviewScreen extends StatefulWidget {
  final File documentFile;
  final Function(File file, String caption) onSend;

  const DocumentPreviewScreen({
    super.key,
    required this.documentFile,
    required this.onSend,
  });

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  final TextEditingController _captionController = TextEditingController();
  String? _fileSize;
  String? _fileExtension;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _loadFileInfo();
  }

  void _loadFileInfo() {
    try {
      final file = widget.documentFile;
      _fileName = path.basename(file.path);
      _fileExtension = path
          .extension(file.path)
          .toUpperCase()
          .replaceAll('.', '');

      final bytes = file.lengthSync();
      if (bytes < 1024) {
        _fileSize = '$bytes B';
      } else if (bytes < 1024 * 1024) {
        _fileSize = '${(bytes / 1024).toStringAsFixed(2)} KB';
      } else {
        _fileSize = '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
      }

      setState(() {});
    } catch (e) {
      debugPrint('❌ Error loading file info: $e');
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _sendDocument() {
    widget.onSend(widget.documentFile, _captionController.text.trim());
    Navigator.of(context).pop();
  }

  IconData _getFileIcon() {
    final ext = _fileExtension?.toLowerCase() ?? '';

    // Document types
    if (['PDF'].contains(ext)) {
      return Icons.picture_as_pdf;
    } else if (['DOC', 'DOCX'].contains(ext)) {
      return Icons.description;
    } else if (['XLS', 'XLSX'].contains(ext)) {
      return Icons.table_chart;
    } else if (['PPT', 'PPTX'].contains(ext)) {
      return Icons.slideshow;
    } else if (['TXT'].contains(ext)) {
      return Icons.text_snippet;
    } else if (['ZIP', 'RAR', '7Z'].contains(ext)) {
      return Icons.folder_zip;
    } else {
      return Icons.insert_drive_file;
    }
  }

  Color _getFileColor() {
    final ext = _fileExtension?.toLowerCase() ?? '';

    if (['PDF'].contains(ext)) {
      return Colors.red;
    } else if (['DOC', 'DOCX'].contains(ext)) {
      return Colors.blue;
    } else if (['XLS', 'XLSX'].contains(ext)) {
      return Colors.green;
    } else if (['PPT', 'PPTX'].contains(ext)) {
      return Colors.orange;
    } else if (['TXT'].contains(ext)) {
      return Colors.grey;
    } else if (['ZIP', 'RAR', '7Z'].contains(ext)) {
      return Colors.amber;
    } else {
      return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          S.of(context).document,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // File Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _getFileColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getFileIcon(),
                          size: 60,
                          color: _getFileColor(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // File Extension Badge
                      if (_fileExtension != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getFileColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _fileExtension!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // File Name
                      Text(
                        _fileName ?? 'Document',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // File Size
                      if (_fileSize != null)
                        Text(
                          _fileSize!,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Caption Input and Send Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _captionController,
                      maxLines: 3,
                      minLines: 1,
                      maxLength: 1000,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: S.of(context).addCaption,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                        filled: true,
                        fillColor:
                            isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendDocument,
                      tooltip: S.of(context).send,
                    ),
                  ),
                ],
              ),
            ),
          ),  
        ],
      ),
    );
  } 
}