// lib/features/stories/presentation/widgets/chat_list/stories_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../post/presentation/widget/get_posts_when_user_follow.dart';
import '../../controllers/story_cubit.dart';
import '../../controllers/story_state.dart';
import '../../pages/story_viewer_page.dart';
import '../common/app_strings.dart';
import '../story_messages/create_story_modal.dart';
import '../story_messages/story_thumbnail.dart';

class StoriesBar extends StatelessWidget {
  const StoriesBar({super.key, required this.imagePath, required this.petID});
  final String imagePath;
  final String petID;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state.status == StoryStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.storyPostedSuccess(context))),
          );
          context.read<StoryCubit>().clearError();
        } else if (state.status == StoryStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: SizedBox(
        height: 110,
        child: BlocBuilder<StoryCubit, StoryState>(
          builder: (context, state) {
            final stories = state.stories;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: stories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _YourStoryTile(
                    imageUrl: imagePath,
                    onTap: () {
                      if (petID.isEmpty) {
                        showGuideOverlay(context);
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder:
                              (_) => BlocProvider.value(
                                value: StoryCubit.get(context),
                                child: const CreateStoryModal(),
                              ),
                        );
                      }
                    },
                  );
                }
                final story = stories[index - 1];
                return StoryThumbnail(
                  avatarUrl: story.ownerAvatarUrl,
                  label: story.ownerName,
                  hasActiveStory: !story.isExpired,
                  onTap: () {
                    if (petID.isEmpty) {
                      showGuideOverlay(context);
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (_) => BlocProvider.value(
                          value: StoryCubit.get(context),
                          child: StoryViewerPage(
                            stories: [story],
                            initialIndex: index,
                          ),
                        ),
                      );
                    }

                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _YourStoryTile extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;
  const _YourStoryTile({required this.onTap, required this.imageUrl});

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
                avatarUrl: imageUrl,
                label: '',
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
