import 'package:flutter/material.dart';
import 'package:squeak/features/layout/post/presentation/widget/post_item.dart';

import '../controller/post_cubit.dart';
import 'build_post_item_shimmer.dart';



NotificationListener<ScrollNotification> buildNotificationListenerUserPosts(
    PostCubit cubit, PostState state) {
  return NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      if (notification is ScrollUpdateNotification &&
          notification.metrics.pixels == notification.metrics.maxScrollExtent &&
          state is! PaginationLoadingState) {
        cubit.getAllUserPosts(pagination: true);
      }
      return true;
    },
    child: RefreshIndicator(
      onRefresh: () async {
        await cubit.handleRefresh();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 7,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return BuildPostItem(
                  postItem: cubit.userPosts[index],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
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
