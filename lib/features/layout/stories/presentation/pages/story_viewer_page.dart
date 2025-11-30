import 'dart:async';
import 'package:flutter/material.dart';

import '../../../react/presentation/animated_reaction/flutter_animated_reaction.dart';
import '../../../react/presentation/animated_reaction/reaction_data.dart';
import '../../domain/entities/story.dart';

class StoryViewerPage extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const StoryViewerPage({
    super.key,
    required this.stories,
    required this.initialIndex,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  final TextEditingController _commentController = TextEditingController();

  // Timer and animation controllers
  Timer? _storyTimer;
  late AnimationController _progressController;
  static const Duration _storyDuration = Duration(seconds: 5);

  GlobalKey key = GlobalKey();
  int? reactionsIndex;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // Initialize progress animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: _storyDuration,
    )..addStatusListener(_onProgressComplete);

    // Start the first story
    _startStoryTimer();
  }

  void _onProgressComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _goToNextStory();
    }
  }

  void _startStoryTimer() {
    _progressController.reset();
    _progressController.forward();
  }

  void _pauseStory() {
    setState(() => _isPaused = true);
    _progressController.stop();
  }

  void _resumeStory() {
    setState(() => _isPaused = false);
    _progressController.forward();
  }

  void _goToNextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // All stories viewed, close the viewer
      Navigator.of(context).pop();
    }
  }

  void _goToPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _startStoryTimer();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    // Handle comment submission
    _commentController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment sent!')),
    );
  }

  @override
  void dispose() {
    _storyTimer?.cancel();
    _progressController.dispose();
    _pageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          final tapPosition = details.globalPosition.dx;

          // Tap on left side = previous story, right side = next story
          if (tapPosition < screenWidth / 2) {
            _goToPreviousStory();
          } else {
            _goToNextStory();
          }
        },
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
          itemCount: widget.stories.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            final story = widget.stories[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                // Story Image
                Image.network(
                  story.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.white, size: 50),
                    );
                  },
                ),

                // Progress Indicators
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
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: i == _currentIndex
                              ? AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progressController.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              );
                            },
                          )
                              : i < _currentIndex
                              ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }),
                  ),
                ),

                // Header
                Positioned(
                  top: 52,
                  left: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(story.ownerAvatarUrl),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                story.ownerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _getTimeAgo(story.createdAt),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isPaused ? Icons.play_arrow : Icons.pause,
                            color: Colors.white,
                            shadows: const [
                              Shadow(blurRadius: 4, color: Colors.black54),
                            ],
                          ),
                          onPressed: () {
                            if (_isPaused) {
                              _resumeStory();
                            } else {
                              _pauseStory();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black54),
                            ],
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom: reactions + comments
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          // Reaction Button
                          InkWell(
                            key: key,
                            onTap: () {
                              setState(() {
                                if (reactionsIndex != null) {
                                  reactionsIndex = null;
                                } else {
                                  reactionsIndex = 0;
                                }
                              });
                            },
                            onLongPress: () {
                              _pauseStory();
                              AnimatedFlutterReaction().showOverlay(
                                context: context,
                                key: key,
                                onReaction: (val) {
                                  setState(() {
                                    reactionsIndex = val;
                                  });
                                  _resumeStory();
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                  reactionsIndex == null
                                      ? ReactionData.unActiveReactionImage
                                      : reactionsIndex == 0
                                      ? ReactionData.activeReactionImage
                                      : ReactionData.facebookReactionImage[
                                  reactionsIndex!],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Comment Input
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
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
                                      decoration: const InputDecoration(
                                        hintText: 'Send message...',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onTap: _pauseStory,
                                      onSubmitted: (_) {
                                        _addComment();
                                        _resumeStory();
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      _addComment();
                                      _resumeStory();
                                    },
                                  ),
                                ],
                              ),
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
