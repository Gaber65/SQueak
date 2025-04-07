import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/constant/global_function/global_Image.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';

import '../../../../core/helper/cache/cache_helper.dart';
import '../../../../core/helper/remotely/end-points.dart';
import '../../../../core/thames/styles.dart';
import '../../../../generated/l10n.dart';
import '../../controller/comment_cubit.dart';
import '../../models/get_comment_post.dart';
import 'build_edit_comment.dart';

class SuccessComment extends StatelessWidget {
  SuccessComment({
    super.key,
    required this.scaffoldKey,
    required this.comments,
    required this.cubit,
    required this.isScrolle,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Comments> comments;
  final CommentCubit cubit;
  final bool isScrolle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ListView.builder(
        itemCount: comments.length,
        shrinkWrap: !isScrolle,
        physics: isScrolle
            ? const BouncingScrollPhysics()
            : NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: CommentTreeWidget<Comments, Comments>(
              comments[index],
              comments[index].isSelected ? comments[index].replies : [],
              treeThemeData: TreeThemeData(
                lineColor: ColorTheme.primaryColor,
                lineWidth: 1,
              ),
              avatarRoot: (context, data) {
                return PreferredSize(
                  preferredSize: Size.fromRadius(25),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      data.pet == null
                          ? (data.user != null &&
                                  data.user!.imageName != null &&
                                  data.user!.imageName!.isNotEmpty)
                              ? "$imageUrl${data.user!.imageName}"
                              : AssetImageModel.defaultUserImage
                          : (data.pet!.imageName != null &&
                                  data.pet!.imageName!.isNotEmpty)
                              ? "$imageUrl${data.pet!.imageName}"
                              : AssetImageModel.defaultPetImage,
                    ),
                  ),
                );
              },
              contentRoot: (context, data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onLongPress: () {
                        if (data.userId == CacheHelper.getData('clintId')) {
                          CacheHelper.saveData('isBottomSheetOpen', true);
                          cubit.emit(IsBottomSheetOpen());
                          scaffoldKey.currentState!
                              .showBottomSheet(
                                backgroundColor: Colors.white.withOpacity(0),
                                elevation: 0,
                                (context) {
                                  return Material(
                                    elevation: 12,
                                    color: MainCubit.get(context).isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.minimize),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              print(data.image);
                                              navigateToScreen(
                                                context,
                                                EditComment(
                                                  text: data.content,
                                                  image: data.pet == null
                                                      ? data.user != null
                                                          ? "$imageUrl${data.user!.imageName}"
                                                          : ''
                                                      : "$imageUrl${data.pet!.imageName}",
                                                  commentImage: data.image,
                                                  petId: data.petId,
                                                  postId: data.postId,
                                                  id: data.id,
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(S
                                                    .of(context)
                                                    .editComment
                                                    .substring(0, 13)),
                                                Spacer(),
                                                Icon(Icons.edit),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              CommentCubit.get(context)
                                                  .deleteComment(
                                                commentId: data.id,
                                                replies: data.replies,
                                              );
                                              Navigator.of(scaffoldKey
                                                      .currentContext!)
                                                  .pop();
                                            },
                                            child: Row(
                                              children: [
                                                Text(S
                                                    .of(context)
                                                    .deleteComment),
                                                Spacer(),
                                                Icon(Icons.close),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                              .closed
                              .then((value) {
                                CacheHelper.saveData(
                                    'isBottomSheetOpen', false);
                                cubit.emit(IsBottomSheetOpen());
                              });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: MainCubit.get(context).isDark
                              ? Colors.white10
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Text(
                                  '${data.pet == null ? data.user!.fullName : data.pet!.petName}',
                                  style: FontStyleThame.textStyle(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                data.content,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    if (data.image != '') SizedBox(height: 8),
                    if (data.image != '')
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          navigateToScreen(
                              context, GlobalImage(imagePath: data.image));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FastCachedImage(
                            height: 150,
                            fit: BoxFit.cover,
                            width: 200,
                            url: '$imageUrl${data.image}',
                          ),
                        ),
                      ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () {
                            comments[index].isSelected =
                                !comments[index].isSelected;
                            CacheHelper.saveData('isReplayCommentOpen',
                                comments[index].isSelected);
                            CacheHelper.saveData(
                                'replayCommentID', comments[index].id);
                            cubit.emit(UpdateCommentSuccess());
                          },
                          child: DefaultTextStyle(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: MainCubit.get(context).isDark
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                            child: Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  if (data.replies.length > 0)
                                    Icon(Icons.reply_all_rounded),
                                  Text(S.of(context).reply),
                                  SizedBox(width: 8),
                                  if (data.replies.length > 0)
                                    Text(
                                      "${isArabic() ? "عرض" : 'view'} ${data.replies.length}",
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: MainCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.bold),
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(formatFacebookTimePost(data.createdAt)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                );
              },
              contentChild: (context, value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onLongPress: () {
                        if (value.userId == CacheHelper.getData('clintId')) {
                          CacheHelper.saveData('isBottomSheetOpen', true);
                          cubit.emit(IsBottomSheetOpen());
                          scaffoldKey.currentState!
                              .showBottomSheet(
                                backgroundColor: Colors.white.withOpacity(0),
                                elevation: 0,
                                (context) {
                                  return Material(
                                    elevation: 12,
                                    color: MainCubit.get(context).isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.minimize),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              navigateToScreen(
                                                context,
                                                EditComment(
                                                  text: value.content,
                                                  image: value.pet == null
                                                      ? value.user != null
                                                          ? "$imageUrl${value.user!.imageName}"
                                                          : ''
                                                      : "$imageUrl${value.pet!.imageName}",
                                                  commentImage:
                                                      '${value.image}',
                                                  petId: value.petId,
                                                  postId: value.postId,
                                                  id: value.id,
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(S
                                                    .of(context)
                                                    .editComment
                                                    .substring(0, 13)),
                                                Spacer(),
                                                Icon(Icons.edit),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              CommentCubit.get(context)
                                                  .deleteComment(
                                                commentId: value.id,
                                                replies: value.replies,
                                              );
                                              Navigator.of(scaffoldKey
                                                      .currentContext!)
                                                  .pop();
                                            },
                                            child: Row(
                                              children: [
                                                Text(S
                                                    .of(context)
                                                    .deleteComment),
                                                Spacer(),
                                                Icon(Icons.close),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                              .closed
                              .then((value) {
                                CacheHelper.saveData(
                                    'isBottomSheetOpen', false);
                                cubit.emit(IsBottomSheetOpen());
                              });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: MainCubit.get(context).isDark
                              ? Colors.white10
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Text(
                                  '${value.pet == null ? value.user == null ? '' : value.user!.fullName : value.pet!.petName}',
                                  style: FontStyleThame.textStyle(
                                    context: context,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                value.content,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (value.image != '') SizedBox(height: 8),
                    if (value.image != '')
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          navigateToScreen(
                              context, GlobalImage(imagePath: value.image));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FastCachedImage(
                            height: 150,
                            fit: BoxFit.cover,
                            width: 200,
                            url: '$imageUrl${value.image}',
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: MainCubit.get(context).isDark
                                ? Colors.white
                                : Colors.grey[700],
                            fontWeight: FontWeight.bold),
                        child: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(formatFacebookTimePost(value.createdAt)),
                        ),
                      ),
                    )
                  ],
                );
              },
              avatarChild: (context, data) {
                return PreferredSize(
                  preferredSize: Size.fromRadius(25),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      data.pet == null
                          ? (data.user != null &&
                                  data.user!.imageName != null &&
                                  data.user!.imageName!.isNotEmpty)
                              ? "$imageUrl${data.user!.imageName}"
                              : AssetImageModel.defaultUserImage
                          : (data.pet!.imageName != null &&
                                  data.pet!.imageName!.isNotEmpty)
                              ? "$imageUrl${data.pet!.imageName}"
                              : AssetImageModel.defaultPetImage,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
