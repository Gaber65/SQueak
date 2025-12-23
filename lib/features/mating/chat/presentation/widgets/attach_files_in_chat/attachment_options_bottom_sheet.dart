import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/multi_media_preview_screen.dart'
    as multi;
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/camera_screen.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/multi_document_preview_screen.dart';
import 'package:squeak/generated/l10n.dart';

enum AttachmentType { image, video, audio, file }

class AttachmentOptionsBottomSheet extends StatelessWidget {
  final Function(List<File> files, AttachmentType type, {String? caption})
  onAttachmentSelected;

  static const double maxMediaSizeMB = 25.0;

  const AttachmentOptionsBottomSheet({
    super.key,
    required this.onAttachmentSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(List<File> files, AttachmentType type, {String? caption})
    onAttachmentSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AttachmentOptionsBottomSheet(
            onAttachmentSelected: onAttachmentSelected,
          ),
    );
  }

  double _getFileSizeMB(File file) {
    try {
      return file.lengthSync() / (1024 * 1024);
    } catch (e) {
      return 0.0;
    }
  }

  bool _isFileSizeValid(File file, AttachmentType type) {
    final sizeMB = _getFileSizeMB(file);
    return sizeMB <= maxMediaSizeMB; 
  }

  void _showFileSizeWarning(
    BuildContext context,
    File file,
    AttachmentType type,
  ) {
    final sizeMB = _getFileSizeMB(file);
    final maxSize = _getMaxSizeForType(type);
    final typeName = _getTypeNameForDialog(type);

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('❌ File Too Large'),
        content: Text(
          '$typeName size must be $maxSize MB or less.\n\nCurrent: ${sizeMB.toStringAsFixed(2)} MB',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  double _getMaxSizeForType(AttachmentType type) {
    return maxMediaSizeMB; 
  }

  String _getTypeNameForDialog(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return 'Image';
      case AttachmentType.video:
        return 'Video';
      case AttachmentType.audio:
        return 'Audio';
      case AttachmentType.file:
        return 'File';
    }
  }

  Future<void> _handlePhoto(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final files = <File>[];

      for (final pickedFile in pickedFiles) {
        final file = File(pickedFile.path);
        if (!_isFileSizeValid(file, AttachmentType.image)) {
          _showFileSizeWarning(context, file, AttachmentType.image);
          continue;
        }
        files.add(file);
      }

      if (files.isEmpty) return;

      debugPrint('📷 AttachmentSheet: ${files.length} photo(s) selected from gallery');
      await navigator.push(
        MaterialPageRoute(
          builder:
              (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: files,
                mediaType: multi.MediaType.image,
                onSend: (files, caption) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} photo(s) confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.image,
                    caption: caption,
                  );
                },
              ),
        ),
      );
    }
  }

  Future<void> _handleVideo(BuildContext context) async {



    final navigator = Navigator.of(context);
    navigator.pop();

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiVideo();

    if (pickedFiles.isNotEmpty) {
      final files = <File>[];

      for (final pickedFile in pickedFiles) {
        if (pickedFile.path.contains(RegExp(r'\.(mp4|mov|avi|mkv|flv|wmv|webm|3gp|m4v)$', caseSensitive: false))) {
          final file = File(pickedFile.path);
          if (!_isFileSizeValid(file, AttachmentType.video)) {
            _showFileSizeWarning(context, file, AttachmentType.video);
            continue;
          }
          files.add(file);
        }
      }

      if (files.isEmpty) return;

      debugPrint('🎥 AttachmentSheet: ${files.length} video(s) selected from gallery');
      await navigator.push(
        MaterialPageRoute(
          builder:
              (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: files,
                mediaType: multi.MediaType.video,
                onSend: (files, caption) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} video(s) confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.video,
                    caption: caption,
                  );
                },
              ),
        ),
      );
    }
  }

  Future<void> _handleAudio(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'ogg',
          'mp3',
          'm4a',
          'wav',
        ],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final files = <File>[];

        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            
            // Check file size
            if (!_isFileSizeValid(file, AttachmentType.audio)) {
              _showFileSizeWarning(context, file, AttachmentType.audio);
              continue;
            }
            files.add(file);
          }
        }

        if (files.isEmpty) return;

        debugPrint('🎵 AttachmentSheet: ${files.length} audio file(s) selected');

        await navigator.push(
          MaterialPageRoute(
            builder:
                (context) => multi.MultiMediaPreviewScreen(
                  mediaFiles: files,
                  mediaType: multi.MediaType.audio,
                  onSend: (files, caption) {
                    debugPrint(
                      '✅ AttachmentSheet: ${files.length} audio file(s) confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                    );
                    onAttachmentSelected(
                      files,
                      AttachmentType.audio,
                      caption: caption,
                    );
                  },
                ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ AttachmentSheet: Error picking audio file: $e');
    }
  }

  Future<void> _handleCamera(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();

    await navigator.push(
      MaterialPageRoute(
        builder:
            (context) =>
                CameraScreen(onAttachmentSelected: onAttachmentSelected),
      ),
    );
  }

  Future<void> _handleDocument(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final files = <File>[];

        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            if (!_isFileSizeValid(file, AttachmentType.file)) {
              _showFileSizeWarning(context, file, AttachmentType.file);
              continue;
            }
            files.add(file);
          }
        }

        if (files.isEmpty) return;

        debugPrint('📄 AttachmentSheet: ${files.length} document file(s) selected');

        await navigator.push(
          MaterialPageRoute(
            builder:
                (context) => MultiDocumentPreviewScreen(
                  documentFiles: files,
                  onSend: (files, caption) {
                    debugPrint(
                      '✅ AttachmentSheet: ${files.length} document(s) confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                    );
                    onAttachmentSelected(
                      files,
                      AttachmentType.file,
                      caption: caption,
                    );
                  },
                ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ AttachmentSheet: Error picking document file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context,
                  icon: Icons.photo_library_rounded,
                  label: S.of(context).image,
                  color: const Color(0xFFFF4081),
                  onTap: () => _handlePhoto(context),
                ),
                _buildOption(
                  context,
                  icon: Icons.videocam_rounded,
                  label: S.of(context).video,
                  color: const Color(0xFF00BCD4),
                  onTap: () => _handleVideo(context),
                ),
                _buildOption(
                  context,
                  icon: Icons.audiotrack_rounded,
                  label: S.of(context).chatAuido,
                  color: const Color(0xFFFF9800),
                  onTap: () => _handleAudio(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context,
                  icon: Icons.camera_alt_outlined,
                  label: S.of(context).camera,
                  color: const Color(0xFF665CFF),
                  onTap: () => _handleCamera(context),
                ),
                _buildOption(
                  context,
                  icon: Icons.file_copy_rounded,
                  label: S.of(context).document,
                  color: const Color(0xFF00D560),
                  onTap: () {
                    _handleDocument(context);
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.location_on_sharp,
                  label: S.of(context).chatLocation,
                  color: const Color(0xFFFF3939),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
