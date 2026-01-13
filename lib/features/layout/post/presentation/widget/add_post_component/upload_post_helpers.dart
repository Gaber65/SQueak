import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../community/controller/community_cubit.dart';

class UploadPostHelpers {
  /// Detects text direction based on Arabic characters
  static TextDirection getTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Validates file size (max 15MB)
  static bool isValidFileSize(File file, {double maxSizeMB = 15}) {
    try {
      final sizeMB = file.lengthSync() / (1024 * 1024);
      return sizeMB <= maxSizeMB;
    } catch (e) {
      return false;
    }
  }

  /// Gets file size in MB
  static double getFileSizeMB(File file) {
    try {
      return file.lengthSync() / (1024 * 1024);
    } catch (e) {
      return 0.0;
    }
  }

  /// Checks if file is an image based on extension
  static bool isImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  /// Checks if file is a video based on extension
  static bool isVideoFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['mp4', 'mov', 'avi', 'webm'].contains(extension);
  }

  /// Gets file type ('image' or 'video')
  static String getFileType(File file) {
    return isImageFile(file) ? 'image' : 'video';
  }

  /// Validates post content
  static String? validatePostContent({
    required String title,
    required String content,
    required List<File> mediaFiles,
  }) {
    if (title.isEmpty && mediaFiles.isEmpty) {
      return 'Please write something or add media!';
    }

    if (title.length >= 100) {
      return 'Post title cannot exceed 100 characters.';
    }

    if (content.length >= 1000) {
      return 'Post content cannot exceed 1000 characters.';
    }

    for (final file in mediaFiles) {
      if (!isValidFileSize(file)) {
        return 'File size cannot exceed 15MB.';
      }
    }

    return null;
  }

  /// Gets media statistics
  static Map<String, int> getMediaStats(List<String> mediaTypes) {
    final imageCount = mediaTypes.where((type) => type == 'image').length;
    final videoCount = mediaTypes.where((type) => type == 'video').length;
    return {'images': imageCount, 'videos': videoCount};
  }

  /// Formats file size for display
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  /// Gets first name from full name
  static String getFirstName(String fullName) {
    return fullName.split(' ').first;
  }

  /// Checks if post has content
  static bool hasPostContent(String text, List<File> mediaFiles) {
    return text.trim().isNotEmpty || mediaFiles.isNotEmpty;
  }
}

// Constants
class UploadPostConstants {
  static const int maxTitleLength = 100;
  static const int maxContentLength = 1000;
  static const double maxFileSizeMB = 10.0;
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
  ];
  static const List<String> allowedVideoExtensions = [
    'mp4',
    'mov',
    'avi',
    'webm',
  ];
}

// Extension for CommunityCubit to add helper methods
extension CommunityCubitExtensions on CommunityCubit {
  bool get hasMedia => mediaFiles.isNotEmpty;

  int get imageCount => mediaTypes.where((type) => type == 'image').length;

  int get videoCount => mediaTypes.where((type) => type == 'video').length;

  bool canAddMoreMedia() {
    return mediaFiles.length <= 10;
  }

  String get mediaSummary {
    if (mediaFiles.isEmpty) return 'No media';
    final images = imageCount;
    final videos = videoCount;

    if (images > 0 && videos > 0) {
      return '$images photo${images > 1 ? 's' : ''}, $videos video${videos > 1 ? 's' : ''}';
    } else if (images > 0) {
      return '$images photo${images > 1 ? 's' : ''}';
    } else {
      return '$videos video${videos > 1 ? 's' : ''}';
    }
  }
}
