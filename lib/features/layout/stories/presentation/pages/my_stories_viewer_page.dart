import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ADDED: Required for BlocBuilder
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/features/layout/stories/presentation/controllers/story_state.dart';
import 'package:squeak/features/layout/stories/presentation/pages/view_how_react.dart';
import 'package:squeak/features/layout/stories/presentation/widgets/story_list/story_pet_avatar.dart';
import 'package:squeak/generated/l10n.dart';
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

    _loadReactionsForCurrentStory();
  }

  void _loadReactionsForCurrentStory() {
    final story = widget.stories[controller.currentIndex];
    // This triggers the API call. The state will update asynchronously.
    widget.storyCubit.loadStoryReactions(userStoryId: story.id);
  }

  void _showReactionsOverlay(BuildContext context) {
    final story = widget.stories[controller.currentIndex];

    widget.storyCubit.loadStoryReactions(userStoryId: story.id).then((value) {
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        builder:
            (context) => GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Material(
                child: GestureDetector(
                  onTap: () {},
                  child: StoryReactionsView(
                    reactions:
                        widget.storyCubit.state.reactions?.reactions ?? [],
                    currentPetId: widget.petID,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
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
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(ReactionData.getIconForReactType(type)),
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
              final isRTL = Directionality.of(context) == TextDirection.rtl;
              final bottomUIHeight = 100.0;
              final screenHeight = MediaQuery.of(context).size.height;

              if (details.globalPosition.dy > screenHeight - bottomUIHeight) {
                return;
              }

              final width = MediaQuery.of(context).size.width;
              final dx = details.globalPosition.dx;

              if (isRTL) {
                if (dx > width * 2 / 3) {
                  controller.goPrevious();
                } else if (dx < width / 3) {
                  controller.goNext();
                }
              } else {
                if (dx < width / 3) {
                  controller.goPrevious();
                } else if (dx > width * 2 / 3) {
                  controller.goNext();
                }
              }
            },
            onLongPressStart: (details) {
              final bottomUIHeight = 100.0;
              final screenHeight = MediaQuery.of(context).size.height;
              if (details.globalPosition.dy > screenHeight - bottomUIHeight) {
                return;
              }
              controller.pause();
            },
            onLongPressEnd: (_) => controller.resume(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Blurred background layer
                Stack(
                  fit: StackFit.expand,
                  children: [
                    // Blurred background image
                    SafeFastCachedImageExtension.safe(
                      url: imageUrl + (currentStory.image ?? ''),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(color: Colors.black),
                    ),
                    // Dark overlay for better contrast
                    Container(color: Colors.black.withOpacity(0.3)),
                    // Main sharp image
                    SafeFastCachedImageExtension.safe(
                      url: imageUrl + (currentStory.image ?? ''),
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, __, ___) => const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          ),
                    ),
                  ],
                ),
                Positioned(
                  top: 40,
                  left: 8,
                  right: 8,
                  child: Builder(
                    builder: (context) {
                      final isRTL =
                          Directionality.of(context) == TextDirection.rtl;
                      return Row(
                        children: List.generate(widget.stories.length, (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child:
                                  index == controller.currentIndex
                                      ? AnimatedBuilder(
                                        animation:
                                            controller.progressController,
                                        builder: (_, __) {
                                          return FractionallySizedBox(
                                            alignment:
                                                isRTL
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                            widthFactor:
                                                controller
                                                    .progressController
                                                    .value,
                                            child: Container(
                                              height: 3,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                      : index < controller.currentIndex
                                      ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
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
                          child: StoryPetAvatar(
                            image: currentStory.petImage,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStory.petName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCustomTimePost(
                                currentStory.createdAt.toString(),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
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
                      // CHANGED: Wrapped with BlocBuilder to listen for data updates
                      child: BlocBuilder<StoryCubit, StoryState>(
                        bloc: widget.storyCubit, // Explicitly pass the cubit
                        builder: (context, state) {
                          // Get the latest list from the stream
                          final currentReactions =
                              state.reactions?.reactions ?? [];

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                S.of(context).viewReactions,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              // CHANGED: Use the list from 'state', not 'widget'
                              ..._buildReactionIconsPreview(currentReactions),
                              const SizedBox(width: 6),
                              // CHANGED: Use the count from 'state', not 'widget'
                              Text(
                                '${currentReactions.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
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
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
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
}
