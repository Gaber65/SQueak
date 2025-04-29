import 'package:flutter/material.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../controller/comment_cubit.dart';
import '../../screens/build_edit_comment.dart';

class CommentActionSheet extends StatelessWidget {
  final CommentEntity comment;
  const CommentActionSheet({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      color:
          MainCubit.get(context).isDark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.minimize),
            const SizedBox(height: 12),
            _buildOption(
              context,
              text: S.of(context).editComment.substring(0, 13),
              icon: Icons.edit,
              onPressed: () {
                Navigator.of(context).pop();
                navigateToScreen(context, EditComment(comment: comment));
              },
            ),
            const SizedBox(height: 30),
            _buildOption(
              context,
              text: S.of(context).deleteComment,
              icon: Icons.close,
              onPressed: () {
                CommentCubit.get(context).deleteComment(
                  commentId: comment.id,
                  replies: comment.replies,
                );
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      child: Row(children: [Text(text), const Spacer(), Icon(icon)]),
    );
  }
}
