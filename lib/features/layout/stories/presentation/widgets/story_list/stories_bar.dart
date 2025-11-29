// lib/features/stories/presentation/widgets/chat_list/stories_bar.dart
import 'package:flutter/material.dart';
import '../common/app_strings.dart';

class StoriesBar extends StatelessWidget {
  final StoryController controller;
  const StoriesBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Obx(() {
        final status = controller.status.value;
        final stories = controller.stories;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (status == StoryStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.storyPostedSuccess(context))),
            );
            controller.clearError();
          } else if (status == StoryStatus.failure && controller.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.validationSelectImage(context))),
            );
          }
        });

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: stories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _YourStoryTile(onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CreateStoryModal(controller: controller),
                );
              });
            }
            final story = stories[index - 1];
            return StoryThumbnail(
              avatarUrl: story.ownerAvatarUrl,
              label: story.ownerName,
              hasActiveStory: !story.isExpired,
              onTap: () {
                // TODO: open full-screen viewer
              },
            );
          },
        );
      }),
    );
  }
}

class _YourStoryTile extends StatelessWidget {
  final VoidCallback onTap;
  const _YourStoryTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              StoryThumbnail(
                avatarUrl: '',
                label: 'Your Story',
                hasActiveStory: false,
                onTap: onTap,
              ),
              Positioned(
                right: 6,
                bottom: 6,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// TODO: Implement stories_bar.dart