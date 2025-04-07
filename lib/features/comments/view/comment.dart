import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/thames/color_manager.dart';
import 'package:squeak/features/comments/view/widgets/loading_comment.dart';
import 'package:squeak/features/comments/view/widgets/success_comment.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/layout.dart';

import '../../../../generated/l10n.dart';

import '../../../core/helper/build_service/main_cubit/main_cubit.dart';
import '../../../core/helper/cache/cache_helper.dart';
import '../../../core/thames/styles.dart';
import '../controller/comment_cubit.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({
    Key? key,
    required this.postId,
    required this.isAppBar,
  }) : super(key: key);
  final String postId;
  final bool isAppBar;

  final commentController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CommentCubit()
          ..getComment(
            postId: postId,
          );
      },
      child: BlocConsumer<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is CreateCommentSuccess) {
            commentController.clear();
            if (MainCubit.get(context).modelImage != null) {
              MainCubit.get(context).modelImage = null;
              print(MainCubit.get(context).modelImage);
              CommentCubit.get(context).commentImage = null;
            }
          }
        },
        builder: (context, state) {
          var cubit = CommentCubit.get(context);
          var squeakCubit = LayoutCubit.get(context);
          bool isBottomSheetOpen = CacheHelper.getBool('isBottomSheetOpen');

          bool isReplayCommentOpen = CacheHelper.getBool('isReplayCommentOpen');
          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: true,
            appBar: isAppBar ? buildAppBar(context, squeakCubit, state) : null,
            body: (state is GetCommentLoading)
                ? CommentWidget(
                    scaffoldKey: scaffoldKey,
                  )
                : WillPopScope(
                    onWillPop: () async {
                      if (isReplayCommentOpen) {
                        navigateToScreen(context, LayoutScreen());
                        CacheHelper.saveData('isReplayCommentOpen', false);
                        return false;
                      } else {
                        return true;
                      }
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
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isBottomSheetOpen
                ? null
                : buildPaddingFormComment(cubit, context, isReplayCommentOpen),
          );
        },
      ),
    );
  }

  Padding buildPaddingFormComment(
    CommentCubit cubit,
    BuildContext context,
    bool isReplayCommentOpen,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cubit.commentImage != null)
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        4.0,
                      ),
                      image: DecorationImage(
                        image: FileImage(cubit.commentImage!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                      radius: 20.0,
                      child: Icon(
                        Icons.close,
                        size: 16.0,
                      ),
                    ),
                    onPressed: () {
                      cubit.removePostImage();
                    },
                  ),
                ],
              ),
            ),
          if (cubit.commentImage != null)
            const SizedBox(
              height: 12,
            ),
          TextFormField(
            controller: commentController,
            style: FontStyleThame.textStyle(
              context: context,
              fontSize: 15,
            ),
            maxLines: 1,
            decoration: InputDecoration(
              hintText: isReplayCommentOpen
                  ? S.of(context).addReplayComment
                  : S.of(context).addComment,
              contentPadding: EdgeInsetsDirectional.only(
                start: 10,
              ), // prefixIcon: IconButton(
              //   onPressed: () {
              //     cubit.getPostCamera();
              //   },
              //   icon: const Icon(IconlyLight.image),
              // ),
              counterStyle: FontStyleThame.textStyle(
                context: context,
                fontSize: 13,
              ),
              hintStyle: FontStyleThame.textStyle(
                context: context,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontColor: MainCubit.get(context).isDark
                    ? Colors.white54
                    : Colors.black54,
              ),
              suffixIcon: IconButton(
                onPressed: cubit.isLoading
                    ? null
                    : () {
                        if (commentController.text.isNotEmpty) {
                          if (cubit.commentImage != null) {
                            cubit.isLoading = true;
                            cubit.emit(CreateCommentLoading());
                            MainCubit.get(context)
                                .getGlobalImage(
                              file: cubit.commentImage!,
                              uploadPlace: UploadPlace.commentImages.value,
                            )
                                .whenComplete(() {
                              return {
                                cubit.createComment(
                                  postId: postId,
                                  content: commentController.text,
                                  petId: CacheHelper.getData('isPet') == true
                                      ? CacheHelper.getData('activeId')
                                      : null,
                                  image:
                                      MainCubit.get(context).modelImage!.data!,
                                  parentId: isReplayCommentOpen
                                      ? CacheHelper.getData('replayCommentID')
                                      : null,
                                )
                              };
                            });
                          } else {
                            cubit.createComment(
                              postId: postId,
                              content: commentController.text,
                              petId: CacheHelper.getData('isPet') == true
                                  ? CacheHelper.getData('activeId')
                                  : null,
                              image: MainCubit.get(context).modelImage == null
                                  ? ''
                                  : MainCubit.get(context).modelImage!.data!,
                              parentId: isReplayCommentOpen
                                  ? CacheHelper.getData('replayCommentID')
                                  : null,
                            );
                          }
                        }
                      },
                icon: cubit.isLoading
                    ? const CircularProgressIndicator()
                    : const Icon(IconlyLight.send),
              ),
              filled: true,
              fillColor: MainCubit.get(context).isDark
                  ? ColorManager.myPetsBaseBlackColor
                  : Colors.grey.shade200,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusColor: Colors.grey.shade200,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, t, CommentState state) {
    return AppBar(
      title: Text(S.of(context).comments),
      leading: IconButton(
        onPressed: () {
          CacheHelper.saveData('isReplayCommentOpen', false);
          navigateToScreen(context, LayoutScreen());
        },
        icon: Icon(IconlyLight.arrow_left_2),
      ),
      bottom: (state is DeleteCommentLoading)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: LinearProgressIndicator(),
            )
          : null,
    );
  }
}
