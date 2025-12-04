import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class UploadPostAnimations {
  final dynamic controller;


  UploadPostAnimations(this.controller);

  void initializeAnimations() {
    controller.animationController = AnimationController(
      vsync: controller.vsync,
      duration: const Duration(milliseconds: 400),
    );

    controller.fadeAnimation = CurvedAnimation(
      parent: controller.animationController,
      curve: Curves.easeInOut,
    );

    controller.slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller.animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    controller.animationController.forward();
  }
}