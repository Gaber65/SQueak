import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import 'package:squeak/features/layout/stories/presentation/pages/view_how_react.dart';
import 'package:squeak/generated/l10n.dart';
import '../../../../../core/network/end_points.dart';
import '../../../react/domain/repo/base_react_repo.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/story_reaction_entity.dart';
import '../controllers/story_viewer_controller.dart';
import '../../../react/presentation/animated_reaction/flutter_animated_reaction.dart';
import '../../../react/presentation/animated_reaction/reaction_data.dart';

import '../controllers/story_cubit.dart';
import '../widgets/common/delete_story.dart';

class StoryViewerPage extends StatefulWidget {
  final List<StoryEntity> stories;
  final int initialIndex;
  final StoryCubit storyCubit;
  final String petID;
  final FrindStoryEntity? friendsStories;
  const StoryViewerPage({
    super.key,
    this.friendsStories,
    required this.stories,
    required this.initialIndex,
    required this.petID,
    required this.storyCubit,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late StoryViewerController controller;
  final TextEditingController _commentController = TextEditingController();

  GlobalKey key = GlobalKey();
  int? reactionsIndex;
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

    if (widget.petID == widget.stories[controller.currentIndex].petId) {
      widget.storyCubit.loadStoryReactions(
        userStoryId: widget.stories[controller.currentIndex].id,
      );
    } else {
      if (widget.stories[controller.currentIndex].isViewed == false) {
        reactionsIndex = widget.stories[controller.currentIndex].myReactType;
        widget.storyCubit.reactToStory(
          userStoryId: widget.stories[controller.currentIndex].id,
          reactType: 0,
          petId: widget.petID,
        );
      } else {
        reactionsIndex = widget.stories[controller.currentIndex].myReactType;
      }
    }
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
    // Get unique reaction types (limit to 3)
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

  void _addComment() {
    if (!controller.canSendComment(_commentController.text)) return;

    widget.storyCubit.sendReplyMsgToStoryPet(
      userStoryId: widget.stories[controller.currentIndex].id,
      message: _commentController.text,
      replyTo: widget.friendsStories!.petId,
      petId: widget.petID,
    );
    _commentController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Comment sent!")));
  }

  @override
  void dispose() {
    controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _handleStoryView(int index) {
    final story = widget.stories[index];

    // صاحب الستوري → حمل قائمة الريأكشنز فقط
    if (widget.petID == story.petId) {
      widget.storyCubit.loadStoryReactions(userStoryId: story.id);
      return;
    }

    // 1) أول مرة يشوف الستوري (isViewed = false)
    if (!story.isViewed) {
      widget.storyCubit.reactToStory(
        userStoryId: story.id,
        reactType: null,
        petId: widget.petID,
      );
      return;
    }

    // 2) شاف قبل كده وعمل Reaction ⇒ لا تبعت
    if (story.myReactType != null) {
      return;
    }

    // 3) شاف قبل كده ومفيش Reaction ⇒ نبعت
    widget.storyCubit.reactToStory(
      userStoryId: story.id,
      reactType: null,
      petId: widget.petID,
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[controller.currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTapDown: (details) {
          final width = MediaQuery.of(context).size.width;
          final dx = details.globalPosition.dx;
          if (dx < width / 2) {
            controller.goPrevious();
          } else {
            controller.goNext();
          }
        },
        onLongPressStart: (_) => controller.pause(),
        onLongPressEnd: (_) => controller.resume(),
        child: PageView.builder(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.stories.length,
          onPageChanged: (index) {
            controller.changePage(index);
            _handleStoryView(index); // ← أضف هذا
            setState(() {});
          },
          itemBuilder: (_, index) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // IMAGE
                Image.network(
                  imageUrl + (story.image ?? ''),
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
                  child: Builder(
                    builder: (context) {
                      final isRTL = Directionality.of(context) == TextDirection.rtl;
                      final totalStories = widget.stories.length;
                      final currentIndex = controller.currentIndex;
                      
                      return Row(
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: List.generate(totalStories, (i) {
                          // In RTL mode, reverse the index for display order
                          final displayIndex = isRTL ? totalStories - 1 - i : i;
                          final isCurrentStory = displayIndex == currentIndex;
                          final isCompleted = isRTL 
                              ? displayIndex > currentIndex 
                              : displayIndex < currentIndex;
                          
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: isCurrentStory
                                  ? AnimatedBuilder(
                                    animation: controller.progressController,
                                    builder: (_, __) => FractionallySizedBox(
                                      alignment: isRTL 
                                          ? Alignment.centerRight 
                                          : Alignment.centerLeft,
                                      widthFactor: controller.progressController.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  )
                                  : isCompleted
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
                      );
                    },
                  ),
                ),

                // HEADER (Avatar + Name + Close/Delete)
                Positioned(
                  top: 52,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            (widget.friendsStories?.petImage != null &&
                                    widget.friendsStories!.petImage.isNotEmpty)
                                ? NetworkImage(
                                  imageUrl +
                                      (widget.friendsStories?.petImage ??
                                          story.petImage),
                                )
                                : null,
                        child:
                            (widget.friendsStories?.petImage == null ||
                                    widget.friendsStories!.petImage.isEmpty)
                                ? Icon(
                                  Icons.pets, 
                                  color: Colors.black,
                                  size: 20,
                                )
                                : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.friendsStories?.petName ?? story.petName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatFacebookTimePost(
                                story.createdAt.toString(),
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
                      if (story.petId == widget.petID)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            controller.pause();
                            _showDeleteDialog(
                              context,
                              story,
                              widget.storyCubit,
                            );
                          },
                        ),
                    ],
                  ),
                ),

                // BOTTOM REACTIONS + COMMENT
                if (story.petId != widget.petID)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildBottomInput(context),
                  ),

                if (story.petId == widget.petID)
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
                            Text(
                              S.of(context).viewReactions,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            ..._buildReactionIconsPreview(
                              widget.storyCubit.state.reactions?.reactions ??
                                  [],
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            InkWell(
              key: key,
              onTap: () {
                setState(() {
                  reactionsIndex = reactionsIndex == null ? 0 : null;
                });
                widget.storyCubit.reactToStory(
                  userStoryId: widget.stories[controller.currentIndex].id,
                  reactType: reactionsIndex,
                  petId: widget.petID,
                );
              },
              onLongPress: () {
                controller.pause();
                AnimatedFlutterReaction().showOverlay(
                  context: context,
                  key: key,
                  onReaction: (val) {
                    widget.storyCubit.reactToStory(
                      userStoryId: widget.stories[controller.currentIndex].id,
                      reactType: val,
                      petId: widget.petID,
                    );
                    setState(() => reactionsIndex = val);
                    controller.resume();
                  },
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                backgroundImage: AssetImage(
                  reactionsIndex == null
                      ? ReactionData.unActiveReactionImage
                      : reactionsIndex == 0
                      ? ReactionData.activeReactionImage
                      : ReactionData.facebookReactionImage[reactionsIndex!],
                ),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: S.of(context).sendStoryMessage,
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        onTap: controller.pause,
                        onSubmitted: (_) {
                          _addComment();
                          controller.resume();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.near_me, color: Colors.white),
                      onPressed: () {
                        _addComment();
                        controller.resume();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
