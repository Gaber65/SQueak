import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/features/comments/presentation/widget/edit_widget/build_animated_avatar_edit_comment.dart';
import 'package:squeak/features/comments/presentation/widget/edit_widget/build_edit_comment_input_card.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/comment_entity.dart';
import '../controller/comment_cubit.dart';
import '../screens/comment.dart';

class EditComment extends StatefulWidget {
  const EditComment({super.key, required this.comment});
  final CommentEntity comment;

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment>
    with SingleTickerProviderStateMixin {
  final commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final AnimationController _animationController;
  late final Animation<double> _avatarAnimation;

  @override
  void initState() {
    super.initState();

    commentController.text = widget.comment.content;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _avatarAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommentCubit>(),
      child: BlocConsumer<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is UpdateCommentSuccess) {
            commentController.clear();
            navigateAndFinish(
              context,
              CommentScreen(postId: widget.comment.postId),
            );
          }
        },
        builder: (context, state) {
          final cubit = CommentCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.comment.parentId == null ? S.of(context).editCommentPost : S.of(context).editReplyCommentPost),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildEditCommentAvatar(
                          widget.comment,
                          _avatarAnimation,
                          _animationController,
                        ),
                        const SizedBox(width: 12),
                        buildEditCommentInputCard(
                          context,
                          cubit,
                          formKey,
                          commentController,
                          widget.comment,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
