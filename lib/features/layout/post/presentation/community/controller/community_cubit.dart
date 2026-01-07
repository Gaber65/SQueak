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
  Future<void> pickMultipleVideos({required ImageSource source}) async {
    try {
      final XFile? videoFile = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );

      if (videoFile != null) {
        // Check if adding this file would exceed the limit
        if (mediaFiles.length >= maxMediaFiles) {
          emit(
            MediaSelectionErrorState('Maximum $maxMediaFiles files allowed'),
          );
          return;
        }

        mediaFiles.add(File(videoFile.path));
        mediaTypes.add('video');
        emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
      }
    } catch (e) {
      emit(MediaSelectionErrorState('Failed to pick video: $e'));
    }
  }

  // Pick mixed media (both images and videos)
  Future<String?> pickMixedMedia({required ImageSource source}) async {
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
    // First check MIME type if available
    if (file.mimeType != null) {
      if (file.mimeType!.startsWith('video/')) {
        return 'video';
      } else if (file.mimeType!.startsWith('image/')) {
        return 'image';
      }
    }

    // Fallback to file extension
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

    if (videoExtensions.contains(extension)) {
      return 'video';
    } else if (imageExtensions.contains(extension)) {
      return 'image';
    }
    return 'unsupported';
  }

  // Remove a specific media file
  void removeMedia(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      mediaFiles.removeAt(index);
      mediaTypes.removeAt(index);
      emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
    }
  }

  // Clear all media
  void clearAllMedia() {
    mediaFiles.clear();
    mediaTypes.clear();
    emit(NoImageSelectedState());
  }

  bool showBottom = false;

  Future changeBottom() async {
    showBottom = !showBottom;
    emit(NoImageSelectedState());
  }
}
