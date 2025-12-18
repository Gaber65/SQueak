import 'package:flutter/material.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../controller/comment_cubit.dart';

AppBar buildAppBar(BuildContext context, CommentState state) {
  return AppBar(
    centerTitle: true,
    title: Text(S.of(context).comments),

    bottom:
        (state is DeleteCommentLoading)
            ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: LinearProgressIndicator(),
            )
            : null,
  );
}
