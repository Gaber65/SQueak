import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../controller/comment_cubit.dart';

Widget buildPaddingFormComment(
  CommentCubit cubit,
  BuildContext context,
  bool isReplayCommentOpen,
  TextEditingController commentController,
  String postId,
  String petID,
) {
  final isDark = MainCubit.get(context).isDark;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cubit.commentImage != null) ...[
          _buildCommentImagePreview(cubit),
          const SizedBox(height: 12),
        ],
        // IconButton(
        //   onPressed: () {
        //     DioFinalHelper.cancelRequestById('comment');
        //   },
        //   icon: const Icon(Icons.cancel),
        // ),
        TextFormField(
          controller: commentController,
          style: FontStyleThame.textStyle(context: context, fontSize: 15),
          maxLines: 1,
          decoration: InputDecoration(
            hintText:
                isReplayCommentOpen
                    ? S.of(context).addReplayComment
                    : S.of(context).addComment,
            hintStyle: FontStyleThame.textStyle(
              context: context,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontColor: isDark ? Colors.white54 : Colors.black54,
            ),
            counterStyle: FontStyleThame.textStyle(
              context: context,
              fontSize: 13,
            ),
            contentPadding: const EdgeInsetsDirectional.only(start: 10),
            filled: true,
            fillColor:
                isDark
                    ? ColorManager.myPetsBaseBlackColor
                    : Colors.grey.shade200,
            suffixIcon: AnimatedBuilder(
              animation: commentController,
              builder: (context, _) {
                final hasText = commentController.text.isNotEmpty;
                final iconColor =
                    hasText
                        ? Theme.of(context).primaryColor
                        : (isDark ? Colors.white54 : Colors.black54);

                return IconButton(
                  onPressed:
                      (cubit.isLoading || !hasText)
                          ? null
                          : () {
                            cubit.createComment(
                              postId: postId,
                              content: commentController.text,
                              petId: petID,
                              parentId:
                                  isReplayCommentOpen
                                      ? CacheHelper.getData('replayCommentID')
                                      : null,
                            );
                          },
                  icon:
                      cubit.isLoading
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                iconColor,
                              ),
                            ),
                          )
                          : (hasText
                              ? Icon(IconlyBold.send, color: Colors.blue)
                              : Icon(IconlyLight.send, color: iconColor)),
                );
              },
            ),
            border: _noBorder(),
            enabledBorder: _noBorder(),
            focusedBorder: _noBorder(),
            disabledBorder: _noBorder(),
            errorBorder: _noBorder(),
            focusedErrorBorder: _noBorder(),
          ),
        ),
      ],
    ),
  );
}

OutlineInputBorder _noBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  );
}

Widget _buildCommentImagePreview(CommentCubit cubit) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            image: DecorationImage(
              image: FileImage(cubit.commentImage!),
              fit: BoxFit.contain,
            ),
          ),
        ),
        IconButton(
          icon: const CircleAvatar(
            radius: 20.0,
            child: Icon(Icons.close, size: 16.0),
          ),
          onPressed: cubit.removeCommentImage,
        ),
      ],
    ),
  );
}
