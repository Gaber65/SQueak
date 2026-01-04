import 'dart:io';
import 'package:flutter/material.dart';
import 'package:squeak/generated/l10n.dart';

class MultiDocumentPreviewScreen extends StatefulWidget {
  final List<File> documentFiles;
  final Function(List<File> files, String caption) onSend;
  final Future<List<File>> Function()? onAddMore;

  static const double maxMediaSizeMB = 25.0;
  static const int maxMediaCount = 10;

  const MultiDocumentPreviewScreen({
    super.key,
    required this.documentFiles,
    required this.onSend,
    this.onAddMore,
  });

  @override
  State<MultiDocumentPreviewScreen> createState() => _MultiDocumentPreviewScreenState();
}

class _MultiDocumentPreviewScreenState extends State<MultiDocumentPreviewScreen> {
  late List<File> _documentFiles;
  int _currentIndex = 0;
  final TextEditingController _captionController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _documentFiles = List.from(widget.documentFiles, growable: true);
    _checkTotalFileSize();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  /// Public method to add more document files from outside the widget
  /// Filters out duplicates automatically
  void addDocumentFiles(List<File> newFiles) {
    _addMoreDocuments(newFiles);
  }

  bool _isFileAlreadySelected(File file) {
    return _documentFiles.any((f) => f.path == file.path);
  }

  Future<void> _addMoreDocuments(List<File> newFiles) async {
    final int initialCount = _documentFiles.length;
    final int availableSlots = MultiDocumentPreviewScreen.maxMediaCount - initialCount;
    int filesAdded = 0;

    setState(() {
      for (final file in newFiles) {
        // Stop adding files if we've reached the limit
        if (_documentFiles.length >= MultiDocumentPreviewScreen.maxMediaCount) {
          break;
        }
        // Skip duplicate files
        if (!_isFileAlreadySelected(file)) {
          _documentFiles.add(file);
          filesAdded++;
        }
      }
    });

    // Show dialog if unable to add all files
    if (filesAdded < newFiles.length && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'File Limit Reached',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            availableSlots == 0
                ? 'You can only add up to ${MultiDocumentPreviewScreen.maxMediaCount} files total.'
                : 'You can only add $availableSlots more file(s). Added $filesAdded out of ${newFiles.length} selected files.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF6200EA)),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _getFileName() {
    return _documentFiles[_currentIndex].path.split('/').last;
  }

  double _getFileSizeMB(File file) {
    try {
      return file.lengthSync() / (1024 * 1024);
    } catch (e) {
      return 0.0;
    }
  }

  double _getTotalFileSizeMB() {
    double totalSize = 0;
    for (final file in _documentFiles) {
      totalSize += _getFileSizeMB(file);
    }
    return totalSize;
  }

  void _checkTotalFileSize() {
    final totalSizeMB = _getTotalFileSizeMB();
    if (totalSizeMB > MultiDocumentPreviewScreen.maxMediaSizeMB) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSizeWarningDialog(totalSizeMB);
      });
    }
  }

  void _showSizeWarningDialog(double totalSizeMB) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'File Size Warning',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'The total size of selected documents is ${totalSizeMB.toStringAsFixed(2)} MB. '
          'Please keep it under ${MultiDocumentPreviewScreen.maxMediaSizeMB.toInt()} MB.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Go Back',
              style: TextStyle(color: Color(0xFF6200EA)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Continue',
              style: TextStyle(color: Color(0xFF6200EA)),
            ),
          ),
        ],
      ),
    );
  }

  String _getFileSizeFormatted() {
    final sizeMB = _getFileSizeMB(_documentFiles[_currentIndex]);
    if (sizeMB < 1) {
      return '${(sizeMB * 1024).toStringAsFixed(1)} KB';
    }
    return '${sizeMB.toStringAsFixed(2)} MB';
  }

  String _getFileExtension() {
    final name = _getFileName();
    if (name.contains('.')) {
      return name.split('.').last.toUpperCase();
    }
    return 'FILE';
  }

  IconData _getFileIcon() {
    final ext = _getFileExtension().toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileIconColor() {
    final ext = _getFileExtension().toLowerCase();
    switch (ext) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'zip':
      case 'rar':
      case '7z':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _previousFile() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _nextFile() {
    if (_currentIndex < _documentFiles.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  Future<void> _handleSend() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    final caption = _captionController.text.trim();
  
    widget.onSend(_documentFiles, caption);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  void _removeDocument(int index) {
    setState(() {
      _documentFiles.removeAt(index);

      // Adjust current index if necessary
      if (_currentIndex >= _documentFiles.length && _documentFiles.isNotEmpty) {
        _currentIndex = _documentFiles.length - 1;
      }

      // If all files are removed, go back
      if (_documentFiles.isEmpty) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _handleBack,
        ),
        title: Text(
          '${S.of(context).preview} (${_currentIndex + 1}/${_documentFiles.length})',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(40),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getFileIconColor().withOpacity(0.7),
                            _getFileIconColor().withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _getFileIconColor().withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getFileIcon(),
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _getFileExtension(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getFileName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getFileSizeFormatted(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_documentFiles.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _currentIndex > 0 ? _previousFile : null,
                            icon: const Icon(Icons.navigate_before),
                            color: _currentIndex > 0 ? Colors.white : Colors.grey,
                            iconSize: 32,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${_currentIndex + 1} / ${_documentFiles.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _currentIndex < _documentFiles.length - 1
                                ? _nextFile
                                : null,
                            icon: const Icon(Icons.navigate_next),
                            color: _currentIndex < _documentFiles.length - 1
                                ? Colors.white
                                : Colors.grey,
                            iconSize: 32,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          // File list preview
          if (_documentFiles.isNotEmpty)
            Container(
              height: 100,
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _documentFiles.length + (_documentFiles.length < MultiDocumentPreviewScreen.maxMediaCount ? 1 : 0),
                itemBuilder: (context, index) {
                  // Add button for adding more documents
                  if (index == _documentFiles.length) {
                    return GestureDetector(
                      onTap: () async {
                        // Check if already at max capacity
                        if (_documentFiles.length >= MultiDocumentPreviewScreen.maxMediaCount) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('You can only add up to ${MultiDocumentPreviewScreen.maxMediaCount} files'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          return;
                        }

                        // Call the onAddMore callback and wait for files to be returned
                        if (widget.onAddMore != null) {
                          try {
                            final result = await widget.onAddMore!();
                            
                            // If files were returned, add them to the preview
                            if (result.isNotEmpty) {
                              _addMoreDocuments(result);
                            }
                          } catch (e) {
                            debugPrint('Error adding more documents: $e');
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E2E2E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[600]!,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.grey[400],
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentIndex == index
                              ? const Color(0xFF6200EA)
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E2E2E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getFileIcon(),
                                  color: _getFileIconColor(),
                                  size: 32,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _documentFiles[index].path.split('/').last.split('.').last.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Remove button overlay
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeDocument(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2E2E2E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
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
                      enabled: !_isSending,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: S.of(context).addCaption,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6200EA), Color(0xFF9C27B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6200EA).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: _isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white),
                      onPressed: _isSending ? null : _handleSend,
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
