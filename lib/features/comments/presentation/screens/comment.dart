import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../controller/comment_cubit.dart';
import '../widget/comment_widget/build_comment_appbar.dart';
import '../widget/comment_widget/comment_form_field.dart';
import '../widget/comment_widget/loading_comment.dart';
import '../widget/comment_widget/success_comment.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({
    super.key,
    required this.postId,
  });

  final String postId;

  final TextEditingController commentController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommentCubit>()..getComment(postId: postId),
      child: BlocConsumer<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is CreateCommentSuccess) {
            commentController.clear();
          }
        },
        builder: (context, state) {
          final cubit = CommentCubit.get(context);
          final isBottomSheetOpen = CacheHelper.getBool('isBottomSheetOpen');
          final isReplayCommentOpen =
          CacheHelper.getBool('isReplayCommentOpen');

          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: true,
            appBar:buildAppBar(context, state),
            body: _buildBody(context, cubit, state, isReplayCommentOpen),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isBottomSheetOpen
                ? null
                : buildPaddingFormComment(
              cubit,
              context,
              isReplayCommentOpen,
              commentController,
              postId,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      CommentCubit cubit,
      CommentState state,
      bool isReplayCommentOpen,
      ) {
    if (state is GetCommentLoading) {
      return CommentWidget(scaffoldKey: scaffoldKey);
    }

    return WillPopScope(
      onWillPop: () async {
        if (isReplayCommentOpen) {
          CacheHelper.saveData('isReplayCommentOpen', false);
          navigateToScreen(context, LayoutScreen());
          return false;
        }
        return true;
      },
      child: Column(
        children: [
          Expanded(
            child: SuccessComment(
              scaffoldKey: scaffoldKey,
              cubit: cubit,
              isScrolle: true,
              comments: cubit.comments,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
