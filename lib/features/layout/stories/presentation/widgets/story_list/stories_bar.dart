import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/global_widget/toast.dart';
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
      listener: (context, state) {},
      child: SizedBox(
        height: 110,
        child: BlocConsumer<StoryCubit, StoryState>(
          listener: (context, state) {
            if (state.status == StoryStatus.error &&
                state.errorMessage != null) {
              errorToast(context, state.errorMessage!);
            }
            if (state.status == StoryStatus.deleting) {
              successToast(context, AppStrings.deleteStoryisDonw(context));
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final storyCubit = StoryCubit.get(context);

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              children: [
                // Your own story tile
                _YourStoryTile(
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
                              value: storyCubit,
                              child: CreateStoryModal(petId: petID),
                            ),
                      );
                    }
                  },
                ),
                if (state.myStories.isNotEmpty) SizedBox(width: 5),
                // My stories
                if (state.myStories.isNotEmpty)
                  StoryThumbnail(
                    avatarUrl: imageUrl + state.myStories.first.petImage,
                    label: state.myStories.first.petName,
                    hasActiveStory: true,
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
                                value: storyCubit,
                                child: StoryViewerPage(
                                  storyCubit: storyCubit,
                                  stories: state.myStories,
                                  petID: petID,
                                  initialIndex: 0,
                                ),
                              ),
                        );
                      }
                    },
                  ),
                SizedBox(width: 5),
                // Friends stories
                ...state.friendsStories.map((story) {
                  return StoryThumbnail(
                    avatarUrl: imageUrl + story.petImage,
                    label: story.petName,
                    hasActiveStory: true,
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
                                value: storyCubit,
                                child: StoryViewerPage(
                                  storyCubit: storyCubit,
                                  friendsStories: story,
                                  stories: story.userStories,
                                  petID: petID,
                                  initialIndex: 0,
                                ),
                              ),
                        );
                      }
                    },
                  );
                }),
              ],
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
