import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:squeak/generated/l10n.dart';

enum AttachmentType { image, video, audio }

class AttachmentOptionsBottomSheet extends StatelessWidget {
  final Function(File file, AttachmentType type) onAttachmentSelected;

  const AttachmentOptionsBottomSheet({
    super.key,
    required this.onAttachmentSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(File file, AttachmentType type) onAttachmentSelected,
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
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      onAttachmentSelected(File(pickedFile.path), AttachmentType.image);
    }
  }

  Future<void> _handleVideo(BuildContext context) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      onAttachmentSelected(File(pickedFile.path), AttachmentType.video);
    }
  }

  Future<void> _handleAudio(BuildContext context) async {
    Navigator.pop(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        onAttachmentSelected(file, AttachmentType.audio);
      }
    } catch (e) {
      debugPrint('Error picking audio file: $e');
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
