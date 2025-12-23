import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/features/layout/stories/presentation/pages/view_how_react.dart';
import '../../../../../core/network/end_points.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/story_reaction_entity.dart';
import '../controllers/story_viewer_controller.dart';
import '../../../react/presentation/animated_reaction/reaction_data.dart';
import '../../../react/domain/repo/base_react_repo.dart';
import '../controllers/story_cubit.dart';
import '../widgets/common/delete_story.dart';

class MyStoriesViewerPage extends StatefulWidget {
  final List<StoryEntity> stories;
  final int initialIndex;
  final StoryCubit storyCubit;
  final String petID;

  const MyStoriesViewerPage({
    super.key,
    required this.stories,
    required this.initialIndex,
    required this.petID,
    required this.storyCubit,
  });

  @override
  State<MyStoriesViewerPage> createState() => _MyStoriesViewerPageState();
}

class _MyStoriesViewerPageState extends State<MyStoriesViewerPage>
    with SingleTickerProviderStateMixin {
  late StoryViewerController controller;

  @override
  void initState() {
    super.initState();

    controller = StoryViewerController(
      vsync: this,
      storyDuration: const Duration(seconds: 30),
      initialIndex: widget.initialIndex,
      onNextStory: _goToNextStory,
      onPreviousStory: _goToPreviousStory,
      onPageChanged: (index) {
        setState(() {});
      },
      onClose: () => Navigator.of(context).pop(),
      onPauseUI: () => setState(() {}),
      onResumeUI: () => setState(() {}),
    );

    // Load reactions for the first story
    _loadReactionsForCurrentStory();
  }

  void _loadReactionsForCurrentStory() {
    final story = widget.stories[controller.currentIndex];
    widget.storyCubit.loadStoryReactions(userStoryId: story.id);
  }

  void _showReactionsOverlay(BuildContext context) {
    final story = widget.stories[controller.currentIndex];

    widget.storyCubit.loadStoryReactions(userStoryId: story.id).then((value) {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder:
            (context) => StoryReactionsOverlay(
              reactions: widget.storyCubit.state.reactions?.reactions ?? [],
              currentPetId: widget.petID,
              onClose: () => Navigator.of(context).pop(),
            ),
      ).then((value) {
        controller.resume();
      });
    });
  }

  List<Widget> _buildReactionIconsPreview(List<StoryReactionEntity> reactions) {
    final uniqueReactions = reactions
        .map((r) => ReactType.fromInt(r.reactType))
        .toSet()
        .toList()
        .take(3);

    return uniqueReactions.map((type) {
      return Container(
        margin: const EdgeInsets.only(right: 4),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ReactionData.facebookReactionIcon[type.value]),
            fit: BoxFit.contain,
          ),
        ),
      );
    }).toList();
  }

  void _goToNextStory() {
    if (controller.currentIndex < widget.stories.length - 1) {
      controller.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goToPreviousStory() {
    if (controller.currentIndex > 0) {
      controller.pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.stories.length,
        onPageChanged: (index) {
          controller.changePage(index);
          _loadReactionsForCurrentStory();
          setState(() {});
        },
        itemBuilder: (_, index) {
          final currentStory = widget.stories[index];

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (details) {
              // Ignore taps if the user is interacting with bottom UI
              final bottomUIHeight =
                  100.0; // Approximate height of reactions button area
              final screenHeight = MediaQuery.of(context).size.height;

              if (details.globalPosition.dy > screenHeight - bottomUIHeight) {
                return; // Don't navigate if tapping in bottom UI area
              }

              final width = MediaQuery.of(context).size.width;
              final dx = details.globalPosition.dx;

              if (dx < width / 3) {
                controller.goPrevious();
              } else if (dx > width * 2 / 3) {
                controller.goNext();
              }
            },
            onLongPressStart: (details) {
              // Ignore long press if in bottom UI area
              final bottomUIHeight = 100.0;
              final screenHeight = MediaQuery.of(context).size.height;

              if (details.globalPosition.dy > screenHeight - bottomUIHeight) {
                return; // Let the UI handle it
              }
              controller.pause();
            },
            onLongPressEnd: (_) => controller.resume(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // IMAGE
                Image.network(
                  imageUrl + (currentStory.image ?? ''),
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                ),

                // PROGRESS INDICATORS
                Positioned(
                  top: 40,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: List.generate(widget.stories.length, (i) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child:
                              i == controller.currentIndex
                                  ? AnimatedBuilder(
                                    animation: controller.progressController,
                                    builder:
                                        (_, __) => FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor:
                                              controller
                                                  .progressController
                                                  .value,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                  )
                                  : i < controller.currentIndex
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  )
                                  : const SizedBox.shrink(),
                        ),
                      );
                    }),
                  ),
                ),

                // HEADER
                Positioned(
                  top: 52,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade800,
                        child: ClipOval(
                          child: _buildPetAvatar(currentStory.petImage),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStory.petName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatFacebookTimePost(
                                currentStory.createdAt.toString(),
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          controller.pause();
                          _showDeleteDialog(
                            context,
                            currentStory,
                            widget.storyCubit,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // REACTIONS BUTTON
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      controller.pause();
                      _showReactionsOverlay(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'View',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          ..._buildReactionIconsPreview(
                            widget.storyCubit.state.reactions?.reactions ?? [],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.storyCubit.state.reactions?.reactions.length ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    StoryEntity storyItem,
    StoryCubit storyCubit,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: DeleteDialogContentStory(
            storyCubit: storyCubit,
            context: context,
            storyItem: storyItem,
          ),
        );
      },
    ).then((value) {
      controller.resume();
    });
  }

  Widget _buildPetAvatar(String? image) {
    if (image == null || image.isEmpty) {
      return _petIcon();
    }

    return Image.network(
      imageUrl + image,
      width: 36,
      height: 36,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _petIcon();
      },
    );
  }

  Widget _petIcon() {
    return Icon(Icons.pets, size: 18, color: Colors.grey.shade400);
  }
}
