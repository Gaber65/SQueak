// EditCommentSaveButton
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../controller/comment_cubit.dart';

Widget buildEditCommentSaveButton(
  BuildContext context,
  CommentCubit cubit,
  GlobalKey<FormState> formKey,
  TextEditingController commentController,
  CommentEntity comment,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.purple[500]!, Colors.pink[500]!],
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final commentPetId = comment.petId.toString();
              cubit.updateComment(
                postId: comment.postId,
                commentId: comment.id,
                content: commentController.text,
                petId: commentPetId,
                image: comment.image,
                parentId:
                    CacheHelper.getData('isReplayCommentOpen') == true
                        ? CacheHelper.getData('replayCommentID')
                        : null,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: BlocBuilder<CommentCubit, CommentState>(
            builder: (context, state) {
              if (state is UpdateCommentLoading) {
                return const CircularProgressIndicator(color: Colors.white);
              }
              return Row(
                children: [
                  const Icon(IconlyLight.send, size: 16),
                  const SizedBox(width: 4),
                  Text(isArabic() ? "حفظ" : "Save"),
                ],
              );
            },
          ),
        ),
      ),
    ],
  );
}
