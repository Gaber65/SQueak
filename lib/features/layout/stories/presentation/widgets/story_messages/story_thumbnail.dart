// lib/features/stories/presentation/widgets/chat_messages/story_thumbnail.dart
import 'package:flutter/material.dart';
import '../common/gradient_ring.dart';

class StoryThumbnail extends StatelessWidget {
  final String avatarUrl;
  final String label;
  final bool hasActiveStory;
  final VoidCallback onTap;

  const StoryThumbnail({
    super.key,
    required this.avatarUrl,
    required this.label,
    required this.hasActiveStory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: GradientRing(
            size: 72,
            active: hasActiveStory,
            child:
                avatarUrl.isNotEmpty
                    ? Image.network(avatarUrl, fit: BoxFit.cover)
                    : Icon(Icons.pets, size: 36, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// TODO: Implement story_thumbnail.dart
