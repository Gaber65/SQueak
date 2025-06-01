import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/controller/notifications_cubit.dart';

import '../../../../../comments/presentation/controller/comment_cubit.dart';
import '../../../../../comments/presentation/widget/comment_widget/success_comment.dart';
import '../../../../post/presentation/widget/build_post_item_shimmer.dart';
import '../../../../post/presentation/widget/post_item.dart';

class PostNotification extends StatelessWidget {
  PostNotification({super.key, required this.id});

  final String id;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CommentCubit>()..getComment(postId: id),
        ),
        BlocProvider(
          create:
              (context) => sl<NotificationsCubit>()..getPostNotification(id),
        ),
      ],
      child: BlocConsumer<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is CreateCommentSuccess) {
            commentController.clear();
          }
        },
        builder: (context, state) {
          var cubit = NotificationsCubit.get(context);
          var cubitComment = CommentCubit.get(context);
          bool isBottomSheetOpen = CacheHelper.getBool('isBottomSheetOpen');

          bool isReplayCommentOpen = CacheHelper.getBool('isReplayCommentOpen');
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  CacheHelper.saveData('isReplayCommentOpen', false);
                  navigateToScreen(context, LayoutScreen());
                },
                icon: const Icon(IconlyLight.arrow_left),
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                if (isReplayCommentOpen) {
                  navigateToScreen(context, LayoutScreen());
                  CacheHelper.saveData('isReplayCommentOpen', false);
                  return false;
                } else {
                  return true;
                }
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  BlocConsumer<NotificationsCubit, NotificationsState>(
                    listener: (context, state) {
                      if (state is GetPostError) {
                        cubit.isLoadingPost = false;
                        cubit.postFound = false;
                      }
                    },
                    builder: (context, state) {
                      return SliverToBoxAdapter(
                        child: Builder(
                          builder: (_) {
                            if (cubit.isLoadingPost) {
                              return BuildPostItemShimmer();
                            }

                            if (cubit.postModel == null) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          0.2,
                                    ),
                                    const Icon(
                                      Icons.error_outline,
                                      size: 80,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      isArabic()
                                          ? 'عذرًا! المنشور غير موجود'
                                          : 'Oops! Post Not Found',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      isArabic()
                                          ? 'نأسف، لكن المنشور الذي تبحث عنه قد تم حذفه أو غير موجود.'
                                          : "We're sorry, but the post you're looking for has been deleted or doesn't exist.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              );
                            }

                            return BuildPostItem(postItem: cubit.postModel!);
                          },
                        ),
                      );
                    },
                  ),
                  if (cubit.postModel != null)
                    SliverList(
                      delegate: SliverChildListDelegate([
                        SuccessComment(
                          scaffoldKey: scaffoldKey,
                          cubit: cubitComment,
                          isScrolle: false,
                          comments: cubitComment.comments,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ]),
                    ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                (cubit.postModel != null)
                    ? isBottomSheetOpen
                        ? null
                        : buildPaddingFormComment(
                          cubitComment,
                          context,
                          isReplayCommentOpen,
                        )
                    : null,
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          if (cubit.commentImage != null) const SizedBox(height: 12),
          TextFormField(
            controller: commentController,
            style: FontStyleThame.textStyle(context: context, fontSize: 15),
            maxLines: 1,
            decoration: InputDecoration(
              hintText:
                  isReplayCommentOpen
                      ? S.of(context).addReplayComment
                      : S.of(context).addComment,
              contentPadding: EdgeInsetsDirectional.only(start: 10),
              // prefixIcon: IconButton(
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
                fontColor:
                    MainCubit.get(context).isDark
                        ? Colors.white54
                        : Colors.black54,
              ),
              suffixIcon: IconButton(
                onPressed:
                    cubit.isLoading
                        ? null
                        : () {
                          if (commentController.text.isNotEmpty) {
                            cubit.createComment(
                              postId: id,
                              content: commentController.text,
                              petId:
                                  CacheHelper.getData('isPet') == true
                                      ? CacheHelper.getData('activeId')
                                      : null,
                              image:
                                  MainCubit.get(context).modelImage == null
                                      ? ''
                                      : MainCubit.get(context).modelImage!.data,
                              parentId:
                                  isReplayCommentOpen
                                      ? CacheHelper.getData('replayCommentID')
                                      : null,
                            );
                          }
                        },
                icon:
                    cubit.isLoading
                        ? const CircularProgressIndicator()
                        : const Icon(IconlyLight.send),
              ),
              filled: true,
              fillColor:
                  MainCubit.get(context).isDark
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
}
