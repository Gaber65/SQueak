import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/features/layout/post/presentation/widget/post_item.dart';
import 'package:squeak/features/layout/stories/presentation/pages/stroy_page.dart';

import '../../../stories/presentation/controllers/story_cubit.dart';
import 'add_post_form.dart';
import '../controller/post_cubit.dart';
import 'build_post_item_shimmer.dart';

GlobalKey buttonKey = GlobalKey();

void showGuideOverlay(BuildContext context) {
  final renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final size = renderBox.size;
  final offset = renderBox.localToGlobal(Offset.zero);

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder:
        (context) => Stack(
          children: [
            // Background with blur + tap-to-dismiss
            GestureDetector(
              onTap: () => overlayEntry.remove(),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
              ),
            ),

            // Centered message card
            Positioned(
              top: 120,
              left: 24,
              right: 24,
              child: AnimatedScale(
                scale: 1,
                duration: const Duration(milliseconds: 300),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isArabic()
                          ? "✨ قبل ما تستخدم الميزة لازم تبدّل للبروفايل ✨"
                          : "✨ Before using the feature, you must switch to the profile ✨",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Highlight around the target button with glow
            Positioned(
              left: offset.dx,
              top: offset.dy,
              width: size.width,
              height: size.height,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
  );

  Overlay.of(context).insert(overlayEntry);
}

NotificationListener<ScrollNotification> buildNotificationListenerUserPosts(
  PostCubit cubit,
  PostState state,
  String petId,
  BuildContext context,
  String imagePath,
) {
  return NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      if (notification is ScrollUpdateNotification &&
          notification.metrics.pixels == notification.metrics.maxScrollExtent &&
          state is! PaginationLoadingState) {
        cubit.getAllUserPosts(petId, pagination: true);
      }
      return true;
    },
    child: RefreshIndicator(
      onRefresh: () async {
        await cubit.handleRefresh(petId);
        await StoryCubit.get(context).loadAllFriendStories(petId);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWhatsonyourmindSanjay(context, petId),

            StoryPage(imagePath: imagePath, petID: petId),

            ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return BuildPostItem(
                  postItem: cubit.userPosts[index],
                  petId: petId,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: cubit.userPosts.length,
              shrinkWrap: true,
            ),
            if (state is PaginationLoadingState)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: BuildPostItemShimmer(),
              ),
          ],
        ),
      ),
    ),
  );
}
