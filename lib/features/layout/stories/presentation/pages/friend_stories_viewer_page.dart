import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/time_format.dart';
import '../../../../../core/network/end_points.dart';
import '../../domain/entities/story.dart';
import '../controllers/story_viewer_controller.dart';
import '../../../react/presentation/animated_reaction/flutter_animated_reaction.dart';
import '../../../react/presentation/animated_reaction/reaction_data.dart';
import '../controllers/story_cubit.dart';

class FriendStoriesViewerPage extends StatefulWidget {
  final List<StoryEntity> stories;
  final int initialIndex;
  final StoryCubit storyCubit;
  final String petID;
  final FrindStoryEntity friendsStories;

  const FriendStoriesViewerPage({
    super.key,
    required this.stories,
    required this.initialIndex,
    required this.petID,
    required this.storyCubit,
    required this.friendsStories,
  });

  @override
  State<FriendStoriesViewerPage> createState() =>
      _FriendStoriesViewerPageState();
}

class _FriendStoriesViewerPageState extends State<FriendStoriesViewerPage>
    with SingleTickerProviderStateMixin {
  late StoryViewerController controller;
  final TextEditingController _commentController = TextEditingController();
  final Map<int, GlobalKey> reactionKeys = {};
  final Map<int, int?> reactionIndices = {};

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

    // Handle first story view
    _handleStoryView(widget.initialIndex);
  }

  GlobalKey _getReactionKey(int index) {
    if (!reactionKeys.containsKey(index)) {
      reactionKeys[index] = GlobalKey();
    }
    return reactionKeys[index]!;
  }

  int? _getReactionIndex(int index) {
    return reactionIndices[index];
  }

  void _setReactionIndex(int index, int? reactTypeValue) {
    setState(() {
      // reactTypeValue can be:
      // null = not viewed/not reacted
      // 0 = viewed but no reaction
      // 1-5 = has reaction
      reactionIndices[index] = reactTypeValue;
    });
  }

  void _handleStoryView(int index) {
    final story = widget.stories[index];

    // Initialize reaction state if not already set
    if (!reactionIndices.containsKey(index)) {
      // If user has already reacted, show that reaction
      if (story.myReactType != null && story.myReactType! > 0) {
        // User has a reaction (1-5)
        reactionIndices[index] = story.myReactType;
      } else if (story.isViewed) {
        // Story is viewed but no reaction
        reactionIndices[index] = 0; // Mark as viewed with no reaction
      } else {
        // First time viewing - not viewed yet
        reactionIndices[index] = null;
        // Send view without reaction (reactType: 0)
        widget.storyCubit.reactToStory(
          userStoryId: story.id,
          reactType: 0, // Send 0 to mark as viewed
          petId: widget.petID,
        );
      }
    }
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
      replyTo: widget.friendsStories.petId,
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
          _handleStoryView(index);
          setState(() {});
        },
        itemBuilder: (_, index) {
          final currentStory = widget.stories[index];

          // Only build the current page and adjacent pages
          if ((index - controller.currentIndex).abs() > 1) {
            return const SizedBox.shrink();
          }

          return _buildStoryPage(context, index, currentStory);
        },
      ),
    );
  }

  Widget _buildStoryPage(
      BuildContext context,
      int index,
      StoryEntity currentStory,
      ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        if (index != controller.currentIndex) return;

        final bottomUIHeight = 120.0;
        final screenHeight = MediaQuery.of(context).size.height;

        if (details.globalPosition.dy > screenHeight - bottomUIHeight) return;

        final width = MediaQuery.of(context).size.width;
        final dx = details.globalPosition.dx;

        if (dx < width / 3) {
          controller.goPrevious();
        } else if (dx > width * 2 / 3) {
          controller.goNext();
        }
      },
      onLongPressStart: (details) {
        if (index != controller.currentIndex) return;

        final bottomUIHeight = 120.0;
        final screenHeight = MediaQuery.of(context).size.height;

        if (details.globalPosition.dy > screenHeight - bottomUIHeight) return;

        controller.pause();
      },
      onLongPressEnd: (_) {
        if (index != controller.currentIndex) return;
        controller.resume();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Creative background with subtle gradient overlay for depth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.1), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Image.network(
              imageUrl + (currentStory.image ?? ''),
              fit: BoxFit.contain,
              errorBuilder:
                  (_, __, ___) =>
              const Center(child: Icon(Icons.error, color: Colors.white)),
            ),
          ),

          // PROGRESS INDICATORS with enhanced styling
          Positioned(
            top: 40,
            left: 8,
            right: 8,
            child: Row(
              children: List.generate(widget.stories.length, (i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4, // Slightly thicker for better visibility
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child:
                    i == controller.currentIndex
                        ? AnimatedBuilder(
                      animation: controller.progressController,
                      builder:
                          (_, __) => FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                        controller.progressController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blueAccent, Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : i < controller.currentIndex
                        ? Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.grey],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                );
              }),
            ),
          ),

          // HEADER with improved styling
          Positioned(
            top: 52,
            left: 8,
            right: 8,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      imageUrl + widget.friendsStories.petImage,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.friendsStories.petName,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatFacebookTimePost(
                          currentStory.createdAt.toString(),
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          if (index == controller.currentIndex)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomInput(context, index),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomInput(BuildContext context, int pageIndex) {
    final reactionKey = _getReactionKey(pageIndex);
    final reactionIndex = _getReactionIndex(pageIndex);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // REACTIONS with Facebook-like styling
            InkWell(
              key: reactionKey,
              onTap: () {
                // Toggle logic for stories:
                // - If no reaction (null) → react with "like" (5)
                // - If has reaction (0-5) → remove reaction (send 0)
                int? newReaction;

                if (reactionIndex == null) {
                  // Not reacted yet - react with "like"
                  newReaction = 5; // ReactType.like.value
                } else {
                  // Already has reaction - remove it
                  newReaction = 0; // ReactType.none.value
                }

                _setReactionIndex(pageIndex, newReaction == 0 ? null : newReaction);

                widget.storyCubit.reactToStory(
                  userStoryId: widget.stories[pageIndex].id,
                  reactType: newReaction, // Send 0 to remove, 5 to like
                  petId: widget.petID,
                );
              },
              onLongPress: () {
                controller.pause();
                AnimatedFlutterReaction().showOverlay(
                  context: context,
                  key: reactionKey,
                  reactions: ReactionData.facebookReactionIcon,
                  onReaction: (uiIndex) {
                    // Convert UI index to react type
                    // UI: 0=happy, 1=sad, 2=love, 3=angry, 4=like
                    // Backend: 1=happy, 2=sad, 3=love, 4=angry, 5=like
                    int reactType = uiIndex + 1;

                    _setReactionIndex(pageIndex, reactType);

                    widget.storyCubit.reactToStory(
                      userStoryId: widget.stories[pageIndex].id,
                      reactType: reactType,
                      petId: widget.petID,
                    );
                    controller.resume();
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    _getStoryReactionImage(reactionIndex),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // COMMENT INPUT with enhanced styling
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Send message...",
                          hintStyle: TextStyle(color: Colors.white70),
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
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.near_me, color: Colors.white, size: 18),
                      ),
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

  String _getStoryReactionImage(int? reactTypeValue) {
    if (reactTypeValue == null) {
      // No reaction yet (not viewed or not reacted)
      return ReactionData.unActiveReactionImage;
    }

    if (reactTypeValue == 0) {
      // Viewed but no reaction
      return ReactionData.unActiveReactionImage;
    }

    // Convert backend react type to UI index
    // Backend: 1=happy, 2=sad, 3=love, 4=angry, 5=like
    // UI arrays: [happy, sad, love, angry, like]
    final uiIndex = reactTypeValue - 1;

    if (reactTypeValue == 5) {
      // "like" reaction
      return ReactionData.activeReactionImage;
    }

    if (uiIndex >= 0 && uiIndex < ReactionData.facebookReactionImage.length) {
      return ReactionData.facebookReactionImage[uiIndex];
    }

    return ReactionData.unActiveReactionImage;
  }
}