import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../../core/utils/export_path/export_files.dart';
import '../../controller/comment_cubit.dart';

bool _hasShownMaxLengthDialog = false;
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
        TextFormField(
          maxLength: 500,
          controller: commentController,
          onChanged: (value) {
            final maxLength = value.length;
            if (maxLength >= 500 && !_hasShownMaxLengthDialog) {
              _hasShownMaxLengthDialog = true;
              showDialog(
                context: context,
                useRootNavigator: true,
                barrierDismissible: true,
                builder: (dialogContext) => CommentMaxLengthDialog(),
              ).then((_) {
                _hasShownMaxLengthDialog = false;
              });
            }
          },
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
                final hasText = commentController.text.trim().isNotEmpty;
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
                              content: commentController.text.trim(),
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

class CommentMaxLengthDialog extends StatelessWidget {
  const CommentMaxLengthDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade600,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).alert,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          S.of(context).commentMaxLength,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed:
              () =>
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade500,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 14,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            S.of(context).ok,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
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
