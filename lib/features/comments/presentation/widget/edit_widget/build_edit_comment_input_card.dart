// EditCommentInputCard
import 'package:flutter/material.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../controller/comment_cubit.dart';
import 'build_edit_comment_save_button.dart';

Widget buildEditCommentInputCard(
  BuildContext context,
  CommentCubit cubit,
  GlobalKey<FormState> formKey,
  TextEditingController commentController,
  CommentEntity comment,
) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color:
            MainCubit.get(context).isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: commentController,
            validator: (value) {
              if (value!.isEmpty) {
                return comment.parentId == null
                    ? isArabic()
                        ? 'تعديل تعليقك'
                        : "Edit your comment"
                    : isArabic()
                    ? 'تعديل ردك'
                    : "Edit your reply";
              }
              return null;
            },
            maxLines: 4,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            cursorHeight: 20,
            style: TextStyle(
              fontSize: 14,
              height: 1.4, // line height to improve multi-line spacing
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black87,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText:
                  comment.parentId == null
                      ? isArabic()
                          ? 'تعديل تعليقك'
                          : "Edit your comment"
                      : isArabic()
                      ? 'تعديل ردك'
                      : "Edit your reply",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            ),
          ),
          const Divider(height: 16, thickness: 1, color: Color(0xFFF5F5F5)),
          buildEditCommentSaveButton(
            context,
            cubit,
            formKey,
            commentController,
            comment,
          ),
        ],
      ),
    ),
  );
}
