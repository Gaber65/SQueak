import 'dart:io';
import 'package:flutter/material.dart';
import '../attach_files_in_chat/attachment_options_bottom_sheet.dart';

class UploadingMedia {
  final String id;
  final File file;
  final AttachmentType type;
  final String caption;

  UploadingMedia({
    required this.id,
    required this.file,
    required this.type,
    required this.caption,
  });
}

class UploadingBubble extends StatelessWidget {
  final UploadingMedia upload;
  final VoidCallback? onCancel;

  const UploadingBubble({super.key, required this.upload, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.7),
                    theme.colorScheme.primary.withOpacity(0.5),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (upload.type == AttachmentType.image) _buildImageUpload(),
                  if (upload.type == AttachmentType.video) _buildVideoUpload(),
                  if (upload.type == AttachmentType.audio) _buildAudioUpload(),
                  if (upload.type == AttachmentType.file) _buildFileUpload(),
                  if (upload.caption.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      upload.caption,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUpload() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.file(upload.file, width: 220, height: 160, fit: BoxFit.cover),
          Positioned.fill(
            child: Container(
              color: Colors.black38,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
          if (onCancel != null)
            Positioned(top: 8, right: 8, child: _buildCancelButton()),
        ],
      ),
    );
  }

  Widget _buildVideoUpload() {
    return Container(
      width: 220,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam, color: Colors.white, size: 40),
              SizedBox(height: 8),
              CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              SizedBox(height: 8),
              Text(
                'Uploading video...',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          if (onCancel != null)
            Positioned(top: 8, right: 8, child: _buildCancelButton()),
        ],
      ),
    );
  }

  Widget _buildAudioUpload() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mic, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
          ),
          const SizedBox(width: 12),
          const Text('Uploading...', style: TextStyle(color: Colors.white)),
          if (onCancel != null) ...[
            const SizedBox(width: 12),
            _buildCancelButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildFileUpload() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
          ),
          const SizedBox(width: 12),
          const Text(
            'Uploading file...',
            style: TextStyle(color: Colors.white),
          ),
          if (onCancel != null) ...[
            const SizedBox(width: 12),
            _buildCancelButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        onCancel!();
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }
}
