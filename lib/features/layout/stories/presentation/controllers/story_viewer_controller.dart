import 'package:flutter/material.dart';

class StoryViewerController {
  late AnimationController progressController;
  late PageController pageController;

  final Duration storyDuration;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final Function(int) onPageChanged;
  final VoidCallback onClose;
  final VoidCallback onPauseUI;
  final VoidCallback onResumeUI;

  bool isPaused = false;
  int currentIndex = 0;

  StoryViewerController({
    required TickerProvider vsync,
    required this.storyDuration,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.onPageChanged,
    required this.onClose,
    required this.onPauseUI,
    required this.onResumeUI,
    required int initialIndex,
  }) {
    currentIndex = initialIndex;
    pageController = PageController(initialPage: initialIndex);

    progressController = AnimationController(
      vsync: vsync,
      duration: storyDuration,
    )..addStatusListener(_onProgressComplete);

    startStory();
  }

  // ------------------------------ STORY PROGRESS --------------------------------

  void _onProgressComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      goNext();
    }
  }

  void startStory() {
    progressController.reset();
    progressController.forward();
  }

  void pause() {
    isPaused = true;
    progressController.stop();
    onPauseUI();
  }

  void resume() {
    isPaused = false;
    progressController.forward();
    onResumeUI();
  }

  // ------------------------------ NAVIGATION -------------------------------------

  void goNext() {
    onNextStory();
  }

  void goPrevious() {
    onPreviousStory();
  }

  void changePage(int index) {
    currentIndex = index;
    onPageChanged(index);
    startStory();
  }

  // ------------------------------ COMMENT ----------------------------------------

  bool canSendComment(String text) => text.trim().isNotEmpty;

  // ------------------------------ CLEANUP ----------------------------------------

  void dispose() {
    progressController.dispose();
    pageController.dispose();
  }
}
