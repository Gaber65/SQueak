import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/layout/post/presentation/controller/post_cubit.dart';
import 'package:squeak/features/layout/post/presentation/widget/appbar_home_item.dart';
import 'package:squeak/features/layout/post/presentation/widget/get_posts_when_user_follow.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../widget/build_search_box.dart';

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
            body:
                (cubit.userPosts.isEmpty)
                    ? buildSearchBox(cubit)
                    : buildNotificationListenerUserPosts(cubit, state),
          );
        },
      ),
    );
  }
}
