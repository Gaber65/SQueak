import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/multi_media_preview_screen.dart'
    as multi;
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/camera_screen.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/multi_document_preview_screen.dart';
import 'package:squeak/generated/l10n.dart';

enum AttachmentType { image, video, file, audio }

// Helper class to hold separated media files
class SeparatedMedia {
  final List<File> images;
  final List<File> videos;

  SeparatedMedia({
    required this.images,
    required this.videos,
  });

  bool get hasImages => images.isNotEmpty;
  bool get hasVideos => videos.isNotEmpty;
  bool get isMixed => hasImages && hasVideos;
}

class AttachmentOptionsBottomSheet extends StatelessWidget {
  final Function(List<File> files, AttachmentType type, {String? caption, List<String?>? captions})
  onAttachmentSelected;

  static const double maxMediaSizeMB = 25.0;
  static const int maxMediaCount = 10;

  const AttachmentOptionsBottomSheet({
    super.key,
    required this.onAttachmentSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(List<File> files, AttachmentType type, {String? caption, List<String?>? captions})
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

  /// Allowed extensions for each file type
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoExtensions = ['mp4', 'webm', 'avi', 'mov'];
  static const List<String> allowedAudioExtensions = ['mp3', 'wav', 'm4a', 'ogg'];

  /// Determine if a file is an image based on its extension
  bool _isImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return allowedImageExtensions.contains(extension);
  }

  /// Determine if a file is a video based on its extension
  bool _isVideoFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return allowedVideoExtensions.contains(extension);
  }

  /// Validate file extension for specific attachment type
  bool _isValidFileExtension(File file, AttachmentType type) {
    final extension = file.path.toLowerCase().split('.').last;
    switch (type) {
      case AttachmentType.image:
        return allowedImageExtensions.contains(extension);
      case AttachmentType.video:
        return allowedVideoExtensions.contains(extension);
      case AttachmentType.audio:
        return allowedAudioExtensions.contains(extension);
      case AttachmentType.file:
        // For documents, allow any extension but we'll validate based on picked type
        return true;
    }
  }

  /// Separate files into images and videos
  SeparatedMedia _separateMediaFiles(List<File> files) {
    final images = <File>[];
    final videos = <File>[];

    for (final file in files) {
      if (_isImageFile(file)) {
        images.add(file);
      } else if (_isVideoFile(file)) {
        videos.add(file);
      }
    }

    return SeparatedMedia(images: images, videos: videos);
  }

  void _showFileSizeWarning(
    BuildContext context,
    File file,
    AttachmentType type,
  ) {
    showDialog(
      context: context,
      builder:
          (c) => AlertDialog(
            title: Text(S.of(context).fileIsTooLarge),
            content: Text(S.of(context).maxFileSize),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(c).pop(),
                child: Text(S.of(context).ok),
              ),
            ],
          ),
    );
  }

  void _showMaxFileCountWarning(BuildContext context, int selectedCount) {
    showDialog(
      context: context,
      builder:
          (c) => AlertDialog(
            title: Text(S.of(context).tooManyFiles),
            content: Text(
              S.of(context).youCanUploadUpTo10Files,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(c).pop(),
                child: Text(S.of(context).ok),
              ),
            ],
          ),
    );
  }

  void _showInvalidExtensionWarning(
    BuildContext context,
    AttachmentType type,
  ) {
    final s = S.of(context);
    String title = s.invalidFileExtension;
    String message = s.invalidFileExtensionMessage;

    switch (type) {
      case AttachmentType.image:
        title = s.invalidImageExtension;
        message = s.invalidImageExtensionMessage;
        break;
      case AttachmentType.video:
        title = s.invalidVideoExtension;
        message = s.invalidVideoExtensionMessage;
        break;
      case AttachmentType.audio:
        title = s.invalidAudioExtension;
        message = s.invalidAudioExtensionMessage;
        break;
      case AttachmentType.file:
        title = s.invalidDocumentExtension;
        message = s.invalidDocumentExtensionMessage;
        break;
    }

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: Text(s.ok),
          ),
        ],
      ),
    );
  }



  Future<void> _handlePhoto(BuildContext context) async {
    try {
      // Use FilePicker to allow selecting both images and videos
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Check if user selected more than max allowed files
        if (result.files.length > maxMediaCount) {
          _showMaxFileCountWarning(context, result.files.length);
          return;
        }

        final navigator = Navigator.of(context);
        navigator.pop();

        final files = <File>[];

        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            
            // Check for invalid extension first
            if (!_isValidFileExtension(file, AttachmentType.image) && 
                !_isValidFileExtension(file, AttachmentType.video)) {
              _showInvalidExtensionWarning(context, AttachmentType.image);
              continue;
            }
            
            if (!_isFileSizeValid(file, AttachmentType.image)) {
              _showFileSizeWarning(context, file, AttachmentType.image);
              continue;
            }
            files.add(file);
          }
        }

        if (files.isEmpty) return;

        // Separate images and videos
        final separated = _separateMediaFiles(files);

        debugPrint(
          '📷 AttachmentSheet: ${files.length} file(s) selected (images: ${separated.images.length}, videos: ${separated.videos.length})',
        );

        // If mixed media, show both in the preview with separate handlers
        if (separated.isMixed) {
          debugPrint('🎨 Mixed media detected - sending images first, then videos');
          await navigator.push(
            MaterialPageRoute(
              builder: (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: files,
                mediaType: multi.MediaType.image,
                onSend: (files, captions) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} media file(s) confirmed with captions',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.image,
                    captions: captions,
                  );
                },
                onAddMore: (mediaType) async {
                  return await _handleAddMoreMedia(context);
                },
              ),
            ),
          );
        } else if (separated.hasVideos) {
          // All videos
          debugPrint('🎥 All videos selected - uploading to video helper');
          await navigator.push(
            MaterialPageRoute(
              builder: (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: separated.videos,
                mediaType: multi.MediaType.video,
                onSend: (files, captions) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} video(s) confirmed with captions',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.video,
                    captions: captions,
                  );
                },
                onAddMore: (mediaType) async {
                  return await _handleAddMoreMedia(context);
                },
              ),
            ),
          );
        } else {
          // All images
          debugPrint('🖼️ All images selected - uploading to image helper');
          await navigator.push(
            MaterialPageRoute(
              builder: (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: separated.images,
                mediaType: multi.MediaType.image,
                onSend: (files, captions) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} image(s) confirmed with captions',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.image,
                    captions: captions,
                  );
                },
                onAddMore: (mediaType) async {
                  return await _handleAddMoreMedia(context);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ AttachmentSheet: Error picking media: $e');
    }
  }

  Future<void> _handleVideo(BuildContext context) async {
    try {
      // Use FilePicker to allow selecting both images and videos
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Check if user selected more than max allowed files
        if (result.files.length > maxMediaCount) {
          _showMaxFileCountWarning(context, result.files.length);
          return;
        }

        final navigator = Navigator.of(context);
        navigator.pop();

        final files = <File>[];

        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            
            // Check for invalid extension first
            if (!_isValidFileExtension(file, AttachmentType.video) && 
                !_isValidFileExtension(file, AttachmentType.image)) {
              _showInvalidExtensionWarning(context, AttachmentType.video);
              continue;
            }
            
            if (!_isFileSizeValid(file, AttachmentType.video)) {
              _showFileSizeWarning(context, file, AttachmentType.video);
              continue;
            }
            files.add(file);
          }
        }

        if (files.isEmpty) return;

        // Separate images and videos
        final separated = _separateMediaFiles(files);

        debugPrint(
          '🎥 AttachmentSheet: ${files.length} file(s) selected (images: ${separated.images.length}, videos: ${separated.videos.length})',
        );

        // If mixed media, show both in the preview with separate handlers
        if (separated.isMixed) {
          debugPrint('🎨 Mixed media detected - sending videos first, then images');
          await navigator.push(
            MaterialPageRoute(
              builder: (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: files,
                mediaType: multi.MediaType.video,
                onSend: (files, captions) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} media file(s) confirmed with captions',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.video,
                    captions: captions,
                  );
                },
                onAddMore: (mediaType) async {
                  return await _handleAddMoreMedia(context);
                },
              ),
            ),
          );
        } else if (separated.hasVideos) {
          // All videos
          debugPrint('🎥 All videos selected - uploading to video helper');
          await navigator.push(
            MaterialPageRoute(
              builder: (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: separated.videos,
                mediaType: multi.MediaType.video,
                onSend: (files, captions) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} video(s) confirmed with captions',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.video,
                    captions: captions,
                  );
                },
                onAddMore: (mediaType) async {
                  return await _handleAddMoreMedia(context);
                },
              ),
            ),
          );
        } else {
          // All images
          debugPrint('🖼️ All images selected - uploading to image helper');
          await navigator.push(
            MaterialPageRoute(
              builder: (context) => multi.MultiMediaPreviewScreen(
                mediaFiles: separated.images,
                mediaType: multi.MediaType.image,
                onSend: (files, captions) {
                  debugPrint(
                    '✅ AttachmentSheet: ${files.length} image(s) confirmed with captions',
                  );
                  onAttachmentSelected(
                    files,
                    AttachmentType.image,
                    captions: captions,
                  );
                },
                onAddMore: (mediaType) async {
                  return await _handleAddMoreMedia(context);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ AttachmentSheet: Error picking media: $e');
    }
  }

  Future<void> _handleAudio(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ogg', 'mp3', 'm4a', 'wav'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Check if user selected more than max allowed files
        if (result.files.length > maxMediaCount) {
          _showMaxFileCountWarning(context, result.files.length);
          return;
        }

        final navigator = Navigator.of(context);
        navigator.pop();

        final files = <File>[];

        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);

            // Check for invalid extension first
            if (!_isValidFileExtension(file, AttachmentType.audio)) {
              _showInvalidExtensionWarning(context, AttachmentType.audio);
              continue;
            }

            // Check file size
            if (!_isFileSizeValid(file, AttachmentType.audio)) {
              _showFileSizeWarning(context, file, AttachmentType.audio);
              continue;
            }
            files.add(file);
          }
        }

        if (files.isEmpty) return;

        debugPrint(
          '🎵 AttachmentSheet: ${files.length} audio file(s) selected',
        );

        await navigator.push(
          MaterialPageRoute(
            builder:
                (context) => multi.MultiMediaPreviewScreen(
                  mediaFiles: files,
                  mediaType: multi.MediaType.audio,
                  onSend: (files, captions) {
                    debugPrint(
                      '✅ AttachmentSheet: ${files.length} audio file(s) confirmed, passing to chat with captions',
                    );
                    onAttachmentSelected(
                      files,
                      AttachmentType.audio,
                      captions: captions,
                    );
                  },
                  onAddMore: (mediaType) async {
                    return await _handleAddMoreAudio(context);
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
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        // Check if user selected more than max allowed files
        if (result.files.length > maxMediaCount) {
          _showMaxFileCountWarning(context, result.files.length);
          return;
        }

        final navigator = Navigator.of(context);
        navigator.pop();

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

        debugPrint(
          '📄 AttachmentSheet: ${files.length} document file(s) selected',
        );

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
                  onAddMore: () async {
                    return await _handleAddMoreDocuments(context);
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

  Future<List<File>> _handleAddMoreMedia(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );

      final files = <File>[];
      bool hasInvalidVideoExtensions = false;
      bool hasInvalidImageExtensions = false;
      
      if (result != null && result.files.isNotEmpty) {
        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            
            // Check for invalid extension
            if (!_isValidFileExtension(file, AttachmentType.image) && 
                !_isValidFileExtension(file, AttachmentType.video)) {
              // Determine which type of file this looks like it should be
              if (_isVideoFile(file)) {
                hasInvalidVideoExtensions = true;
              } else if (_isImageFile(file)) {
                hasInvalidImageExtensions = true;
              } else {
                // If we can't determine, assume it's trying to be a video
                hasInvalidVideoExtensions = true;
              }
              continue;
            }
            
            if (_isFileSizeValid(file, AttachmentType.image)) {
              files.add(file);
            }
          }
        }

        // Show dialog if unsupported media was detected
        if ((hasInvalidImageExtensions || hasInvalidVideoExtensions) && context.mounted) {
          // Show video warning if invalid videos were detected, otherwise image
          if (hasInvalidVideoExtensions) {
            _showInvalidExtensionWarning(context, AttachmentType.video);
          } else {
            _showInvalidExtensionWarning(context, AttachmentType.image);
          }
        }

        if (files.isNotEmpty) {
          debugPrint('🎬 Adding ${files.length} more media file(s)');
        }
      }
      return files;
    } catch (e) {
      debugPrint('❌ Error picking additional media files: $e');
      return [];
    }
  }



  Future<List<File>> _handleAddMoreAudio(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ogg', 'mp3', 'm4a', 'wav'],
      allowMultiple: true,
    );

    final files = <File>[];
    bool hasInvalidExtensions = false;
    
    if (result != null && result.files.isNotEmpty) {
      for (final platformFile in result.files) {
        if (platformFile.path != null) {
          final file = File(platformFile.path!);
          
          // Check for invalid extension
          if (!_isValidFileExtension(file, AttachmentType.audio)) {
            hasInvalidExtensions = true;
            continue;
          }
          
          if (_isFileSizeValid(file, AttachmentType.audio)) {
            files.add(file);
          }
        }
      }

      // Show dialog if unsupported audio was detected
      if (hasInvalidExtensions && context.mounted) {
        _showInvalidExtensionWarning(context, AttachmentType.audio);
      }

      if (files.isNotEmpty) {
        debugPrint('🎵 Adding ${files.length} more audio file(s)');
      }
    }
    return files;
  }

  Future<List<File>> _handleAddMoreDocuments(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      final files = <File>[];
      if (result != null && result.files.isNotEmpty) {
        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            if (_isFileSizeValid(file, AttachmentType.file)) {
              files.add(file);
            }
          }
        }

        if (files.isNotEmpty) {
          debugPrint('📄 Adding ${files.length} more document(s)');
        }
      }
      return files;
    } catch (e) {
      debugPrint('❌ Error picking additional document files: $e');
      return [];
    }
  }
}

