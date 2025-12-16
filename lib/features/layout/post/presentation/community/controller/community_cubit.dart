// community_cubit.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(FeedsInitial());

  static CommunityCubit get(context) {
    return BlocProvider.of(context);
  }

  var textController = TextEditingController();
  var picker = ImagePicker();

  List<File> mediaFiles = [];
  List<String> mediaTypes = [];

  static const int maxMediaFiles = 10;

  // Pick multiple images - now supports both images and videos
  Future<void> pickMultipleImages({required ImageSource source}) async {
    try {
      // Use pickMultipleMedia to allow selecting both images and videos
      final List<XFile> pickedFiles = await picker.pickMultipleMedia(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        if (mediaFiles.length + pickedFiles.length > maxMediaFiles) {
          emit(
            MediaSelectionErrorState('Maximum $maxMediaFiles files allowed'),
          );
          return;
        }

        for (var file in pickedFiles) {
          mediaFiles.add(File(file.path));
          // Detect actual file type based on MIME type or extension
          final fileType = _detectMediaType(file);
          mediaTypes.add(fileType);
        }
        emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
      }
    } catch (e) {
      emit(MediaSelectionErrorState('Failed to pick images: $e'));
    }
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
  Future<void> pickMixedMedia({required ImageSource source}) async {
    try {
      // For mixed media, we'll use pickFiles which allows both
      final List<XFile> files = await picker.pickMultipleMedia(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (files.isNotEmpty) {
        // Check if adding these files would exceed the limit
        if (mediaFiles.length + files.length > maxMediaFiles) {
          emit(
            MediaSelectionErrorState('Maximum $maxMediaFiles files allowed'),
          );
          return;
        }

        for (var file in files) {
          mediaFiles.add(File(file.path));
          // Detect actual file type
          final fileType = _detectMediaType(file);
          mediaTypes.add(fileType);
        }
        emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
      }
    } catch (e) {
      emit(MediaSelectionErrorState('Failed to pick media: $e'));
    }
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
      'mkv',
      'flv',
      'wmv',
      '3gp',
      'm4v',
      'webm',
    ];
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'heic',
      'heif',
    ];

    if (videoExtensions.contains(extension)) {
      return 'video';
    } else if (imageExtensions.contains(extension)) {
      return 'image';
    }
    return 'image';
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
