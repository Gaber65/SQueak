import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/image_preview_screen.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/camera_screen.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/document_preview_screen.dart';
import 'package:squeak/generated/l10n.dart';

enum AttachmentType { image, video, audio, file }

class AttachmentOptionsBottomSheet extends StatelessWidget {
  final Function(File file, AttachmentType type, {String? caption})
  onAttachmentSelected;

  const AttachmentOptionsBottomSheet({
    super.key,
    required this.onAttachmentSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(File file, AttachmentType type, {String? caption})
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

  Future<void> _handlePhoto(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      debugPrint('📷 AttachmentSheet: Photo selected from gallery');
      await navigator.push(
        MaterialPageRoute(
          builder:
              (context) => MediaPreviewScreen(
                mediaFile: File(pickedFile.path),
                mediaType: MediaType.image,
                onSend: (file, caption) {
                  debugPrint(
                    '✅ AttachmentSheet: Photo confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                  );
                  onAttachmentSelected(
                    file,
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
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      debugPrint('🎥 AttachmentSheet: Video selected from gallery');
      await navigator.push(
        MaterialPageRoute(
          builder:
              (context) => MediaPreviewScreen(
                mediaFile: File(pickedFile.path),
                mediaType: MediaType.video,
                onSend: (file, caption) {
                  debugPrint(
                    '✅ AttachmentSheet: Video confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                  );
                  onAttachmentSelected(
                    file,
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
          'aac',
          'ogg',
          'opus',
          'mp3',
          'm4a',
          'midi',
          'amr',
          'wma',
          'wav',
          'webm',
        ],
        allowMultiple: false,
      );

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.single.path != null) {
        final file = File(result.files.single.path!);
        debugPrint('🎵 AttachmentSheet: Audio file selected: ${file.path}');

        await navigator.push(
          MaterialPageRoute(
            builder:
                (context) => MediaPreviewScreen(
                  mediaFile: file,
                  mediaType: MediaType.audio,
                  onSend: (file, caption) {
                    debugPrint(
                      '✅ AttachmentSheet: Audio confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                    );
                    onAttachmentSelected(
                      file,
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
        allowMultiple: false,
      );

      if (result != null &&
          result.files.isNotEmpty &&
          result.files.single.path != null) {
        final file = File(result.files.single.path!);
        debugPrint('📄 AttachmentSheet: Document file selected: ${file.path}');

        await navigator.push(
          MaterialPageRoute(
            builder:
                (context) => DocumentPreviewScreen(
                  documentFile: file,
                  onSend: (file, caption) {
                    debugPrint(
                      '✅ AttachmentSheet: Document confirmed, passing to chat with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
                    );
                    onAttachmentSelected(
                      file,
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
