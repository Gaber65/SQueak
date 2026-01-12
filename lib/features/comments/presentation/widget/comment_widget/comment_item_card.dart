// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';

import '../../../../../core/service/global_widget/global_image.dart';
import '../../../../../core/utils/export_path/export_files.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../controller/comment_cubit.dart';
import 'comment_action_item.dart';

class CommentItemCard extends StatelessWidget {
  final CommentEntity data;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final CommentCubit cubit;
  final int index;
  final List<CommentEntity> comments;
  final bool showReplies;
  final String petID;
  const CommentItemCard({
    super.key,
    required this.data,
    required this.scaffoldKey,
    required this.cubit,
    required this.index,
    required this.petID,
    required this.comments,
    required this.showReplies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onLongPress: () => _onLongPress(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  MainCubit.get(context).isDark
                      ? Colors.white10
                      : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,

                  child: Text(
                    data.pet?.petName ?? data.user?.fullName ?? '',
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.content,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (data.image.isNotEmpty) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              navigateToScreen(context, GlobalImage(imagePath: data.image));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SafeFastCachedImageExtension.safe(
                height: 150,
                fit: BoxFit.cover,
                width: 200,
                url: '$imageUrl${data.image}',
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        _buildReplyAndTimestamp(context),
        const SizedBox(height: 15),
      ],
    );
  }

  void _onLongPress(BuildContext context) {
    if (data.userId == CacheHelper.getData('clintId') && 
        petID == data.petId) {
      CacheHelper.saveData('isBottomSheetOpen', true);
      cubit.emit(IsBottomSheetOpen());
      scaffoldKey.currentState!
          .showBottomSheet(
            backgroundColor: Colors.transparent,
            elevation: 0,
            (context) => CommentActionSheet(comment: data, petID: petID),
          )
          .closed
          .then((value) {
            CacheHelper.saveData('isBottomSheetOpen', false);
            cubit.emit(IsBottomSheetOpen());
          });
    }
  }

  Widget _buildReplyAndTimestamp(BuildContext context) {
    return Row(
      children: [
        if (showReplies)
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () {
              comments[index].isSelected = !comments[index].isSelected;
              CacheHelper.saveData(
                'isReplayCommentOpen',
                comments[index].isSelected,
              );
              CacheHelper.saveData('replayCommentID', comments[index].id);
              cubit.emit(UpdateCommentSuccess());
            },
            child: Row(
              children: [
                if (data.replies.isNotEmpty)
                  const Icon(Icons.reply_all_rounded),
                const SizedBox(width: 8),

                Text(
                  data.replies.isEmpty
                      ? S.of(context).reply
                      : data.replies.length == 1
                      ? S.of(context).view1Reply
                      : S.of(context).viewReplies(data.replies.length),
                ),
              ],
            ),
          ),
        const Spacer(),
        Text(
          formatFacebookTimePost(data.createdAt),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color:
                MainCubit.get(context).isDark ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
