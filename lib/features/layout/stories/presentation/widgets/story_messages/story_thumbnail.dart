// lib/features/stories/presentation/widgets/chat_messages/story_thumbnail.dart
import 'package:flutter/material.dart';
import '../common/gradient_ring.dart';

class StoryThumbnail extends StatelessWidget {
  final String? avatarUrl; // خليها nullable
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
            child: _buildAvatar(),
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

  Widget _buildAvatar() {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return _petIcon();
    }

    return ClipOval(
      child: Image.network(
        avatarUrl!,
        fit: BoxFit.cover,
        width: 72,
        height: 72,
        errorBuilder: (context, error, stackTrace) {
          return _petIcon();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
      ),
    );
  }

  Widget _petIcon() {
    return Center(
      child: Icon(
        Icons.pets,
        size: 36,
        color: Colors.grey.shade600,
      ),
    );
  }
}


