// lib/features/stories/presentation/widgets/common/validators.dart
import 'dart:io';
import 'package:mime/mime.dart';

class ImageValidationResult {
  final bool isValid;
  final String? message;
  ImageValidationResult(this.isValid, [this.message]);
}

class ImageValidator {
  static const maxBytes = 10 * 1024 * 1024; // 10MB
  static const allowedMime = {
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  };

  static ImageValidationResult validate(File file) {
    if (!file.existsSync()) {
      return ImageValidationResult(false, 'Please select an image to continue.');
    }
    final length = file.lengthSync();
    if (length > maxBytes) {
      return ImageValidationResult(false, 'Image exceeds 10MB limit.');
    }
    final mime = lookupMimeType(file.path);
    if (mime == null || !allowedMime.contains(mime)) {
      return ImageValidationResult(false, 'Unsupported format. Use JPG, PNG, GIF, or WebP.');
    }
    return ImageValidationResult(true);
  }
}
