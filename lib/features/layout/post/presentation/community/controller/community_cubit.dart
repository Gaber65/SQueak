// community_cubit.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:squeak/generated/l10n.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(FeedsInitial());

  static CommunityCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  var textController = TextEditingController();
  var picker = ImagePicker();

  List<File> mediaFiles = [];
  List<String> mediaTypes = [];
  List<bool> unsupportedFiles = []; 

  static const int maxMediaFiles = 10;

  // Pick multiple images - now supports both images and videos
  Future<void> pickMultipleImages({required ImageSource source, required BuildContext context}) async {
    try {
      final List<XFile> pickedFiles = await picker.pickMultipleMedia();

      if (pickedFiles.isEmpty) return;

      if (mediaFiles.length + pickedFiles.length > maxMediaFiles) {
        emit(MediaSelectionErrorState('Maximum $maxMediaFiles files allowed'));
        return;
      }

      for (var file in pickedFiles) {
        final fileObj = File(file.path);
        final fileType = _detectImageType(file);

        // تحقق من نوع الصورة
        if (fileType == 'unsupported') {
          mediaFiles.add(fileObj);
          mediaTypes.add('unsupported');
          unsupportedFiles.add(true); 
          emit(
            MediaSelectionErrorState(
              '${S.of(context).supportedFormats}: JPG, JPEG, PNG, GIF',
            ),
          );
          continue;
        }

        // تحقق من حجم الصورة
        final fileSize = await fileObj.length();
        if (fileSize > 10 * 1024 * 1024) {
          // 10MB
          mediaFiles.add(fileObj);
          mediaTypes.add('oversized');
          unsupportedFiles.add(true); 
          emit(
            MediaSelectionErrorState(
              'File ${file.name} is too large (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB). Max allowed: 10 MB',
            ),
          );
          continue;
        }

        // إضافة الملف المقبول
        mediaFiles.add(fileObj);
        mediaTypes.add(fileType);
        unsupportedFiles.add(false);
      }

      if (mediaFiles.isNotEmpty) {
        emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
      }
    } catch (e) {
      emit(MediaSelectionErrorState('Failed to pick media: $e'));
    }
  }

  // كشف نوع الصورة بناءً على الامتداد
  String _detectImageType(XFile file) {
    final path = file.path.toLowerCase();
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.gif')) return 'image/gif';
    // Check MIME type as fallback
    if (file.mimeType != null && file.mimeType!.startsWith('image/')) {
      return file.mimeType!;
    }
    return 'unsupported';
  }

  // Pick multiple videos
  Future<void> pickMultipleVideos({required ImageSource source, required BuildContext context}) async {
    try {
      final XFile? videoFile = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );

      if (videoFile != null) {
        // Validate video extension
        final videoValidation = _validateVideoExtension(videoFile);
        if (videoValidation == 'unsupported_video') {
          mediaFiles.add(File(videoFile.path));
          mediaTypes.add('unsupported');
          unsupportedFiles.add(true); 
          emit(
            MediaSelectionErrorState(
              S.of(context).unsupportedVideoFormatMessage,
            ),
          );
          emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
          return;
        }

        // Check if adding this file would exceed the limit
        if (mediaFiles.length >= maxMediaFiles) {
          emit(
            MediaSelectionErrorState('Maximum $maxMediaFiles files allowed'),
          );
          return;
        }

        // Check file size
        final fileSize = await File(videoFile.path).length();
        if (fileSize > 10 * 1024 * 1024) {
          mediaFiles.add(File(videoFile.path));
          mediaTypes.add('oversized');
          unsupportedFiles.add(true); 
          emit(
            MediaSelectionErrorState(
              'Video is too large (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB). Max allowed: 10 MB',
            ),
          );
          emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
          return;
        }

        mediaFiles.add(File(videoFile.path));
        mediaTypes.add('video');
        unsupportedFiles.add(false); 
        emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
      }
    } catch (e) {
      emit(MediaSelectionErrorState('Failed to pick video: $e'));
    }
  }

  // Pick mixed media (both images and videos)
  Future<String?> pickMixedMedia({required ImageSource source, required BuildContext context}) async {
    try {
      final List<XFile> files = await picker.pickMultipleMedia();

      if (files.isNotEmpty) {
        if (mediaFiles.length + files.length > maxMediaFiles) {
          emit(
            MediaSelectionErrorState('Maximum $maxMediaFiles files allowed'),
          );
          return 'Maximum $maxMediaFiles files allowed';
        }

        for (var file in files) {
          final fileType = _detectMediaType(file);
          
          // Check for unsupported formats
          if (fileType == 'unsupported') {
            emit(
              MediaSelectionErrorState(
                'Unsupported file type: ${file.name}. Supported formats:\nImage: JPG, JPEG, PNG, GIF\nVideo: MP4, WEBM, AVI, MOV',
              ),
            );
            continue;
          }

          // Validate video extension strictly
          if (fileType == 'video') {
            final videoValidation = _validateVideoExtension(file);
            if (videoValidation == 'unsupported_video') {
              emit(
                MediaSelectionErrorState(
                  S.of(context).unsupportedVideoFormatMessage,
                ),
              );
              continue;
            }
          }
          
          final fileSize = await File(file.path).length(); // حجم الملف بالبايت
          const maxSizeInBytes = 10 * 1024 * 1024; // 10 ميجابايت
          if (fileSize > maxSizeInBytes) {
            emit(
              MediaSelectionErrorState(
                'File ${file.name} exceeds the 10 MB limit',
              ),
            );
            continue;
          }
          mediaFiles.add(File(file.path));
          mediaTypes.add(fileType);
        }

        if (mediaFiles.isNotEmpty) {
          emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
        }
      }
    } catch (e) {
      emit(MediaSelectionErrorState('Failed to pick media: $e'));
      return 'Failed to pick media: $e';
    }
    return null;
  }

  // Helper method to detect if a file is an image or video
  String _detectMediaType(XFile file) {
    final extension = file.path.split('.').last.toLowerCase();
    final videoExtensions = [
      'mp4',
      'mov',
      'avi',
      'webm',
    ];
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
    ];

    // Check by extension first for stricter validation
    if (videoExtensions.contains(extension)) {
      return 'video';
    } else if (imageExtensions.contains(extension)) {
      return 'image';
    }

    // Fallback to MIME type
    if (file.mimeType != null) {
      if (file.mimeType!.startsWith('video/')) {
        return 'video';
      } else if (file.mimeType!.startsWith('image/')) {
        return 'image';
      }
    }

    return 'unsupported';
  }

  // Validate if video extension is supported
  String? _validateVideoExtension(XFile file) {
    final extension = file.path.split('.').last.toLowerCase();
    final videoExtensions = ['mp4', 'mov', 'avi', 'webm'];

    if (!videoExtensions.contains(extension)) {
      return 'unsupported_video';
    }
    return null;
  }

  // Remove a specific media file
  void removeMedia(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      mediaFiles.removeAt(index);
      mediaTypes.removeAt(index);
      unsupportedFiles.removeAt(index);
      emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
    }
  }

  // Clear all media
  void clearAllMedia() {
    mediaFiles.clear();
    mediaTypes.clear();
    unsupportedFiles.clear();
    emit(NoImageSelectedState());
  }

  bool showBottom = false;

  Future changeBottom() async {
    showBottom = !showBottom;
    emit(NoImageSelectedState());
  }
}
