import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:squeak/core/network/end_points.dart';

class StoryPetAvatar extends StatelessWidget {
  final String? image;
  final double size;

  const StoryPetAvatar({super.key, this.image, this.size = 36});

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return Icon(
        Icons.pets,
        size: (size / 2).clamp(12.0, 24.0),
        color: Colors.grey.shade400,
      );
    }

    return SafeFastCachedImageExtension.safe(
  url: imageUrl + image!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace,
) {
        return Icon(
          Icons.pets,
          size: (size / 2).clamp(12.0, 24.0),
          color: Colors.grey.shade400,
        );
      },
    );
  }
}
