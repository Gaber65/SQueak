import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/layout/post/presentation/controller/post_cubit.dart';
import 'package:squeak/features/layout/post/presentation/widget/appbar_home_item.dart';
import 'package:squeak/features/layout/post/presentation/widget/get_posts_when_user_follow.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../widget/build_search_box.dart';
import '../widget/loading_posts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostCubit>(),
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = PostCubit.get(context);
          return Scaffold(
            appBar: buildAppBarHome(context),
            body: _buildBody(cubit, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(PostCubit cubit, PostState state) {
    if (state is GetPostLoadingState && cubit.userPosts.isEmpty) {
      return buildShimmerLoading();
    }

    if (cubit.userPosts.isEmpty) {
      return buildSearchBox(cubit);
    }

    return buildNotificationListenerUserPosts(cubit, state);
  }
}
