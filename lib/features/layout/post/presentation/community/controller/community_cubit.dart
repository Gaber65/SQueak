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

  // Multi-media support
  List<File> mediaFiles = [];
  List<String> mediaTypes = []; // 'image' or 'video'

  // Maximum media files allowed
  static const int maxMediaFiles = 10;

  // Pick multiple images
  Future<void> pickMultipleImages({required ImageSource source}) async {
    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage(
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
          mediaTypes.add('image');
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
          // Determine if it's image or video based on MIME type or extension
          if (file.mimeType?.startsWith('video/') ?? false) {
            mediaTypes.add('video');
          } else {
            mediaTypes.add('image');
          }
        }
        emit(MultiMediaSelectedState(mediaFiles, mediaTypes));
      }
    } catch (e) {
      emit(MediaSelectionErrorState('Failed to pick media: $e'));
    }
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
