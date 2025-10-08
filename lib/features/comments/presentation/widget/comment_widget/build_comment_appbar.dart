import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../controller/comment_cubit.dart';

AppBar buildAppBar(BuildContext context, CommentState state) {
  return AppBar(
    centerTitle: true,
    title: Text(S.of(context).comments),
    leading: IconButton(
      onPressed: () {
        CacheHelper.saveData('isReplayCommentOpen', false);
        navigateToScreen(context, LayoutScreen());
      },
      icon: Icon(IconlyLight.arrow_left_2),
    ),
    bottom:
    (state is DeleteCommentLoading)
        ? PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: LinearProgressIndicator(),
    )
        : null,
  );
}