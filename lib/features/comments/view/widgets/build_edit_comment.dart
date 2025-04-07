import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/comments/controller/comment_cubit.dart';
import 'package:squeak/features/comments/view/comment.dart';
import '../../../../core/helper/cache/cache_helper.dart';
import '../../../../generated/l10n.dart';

class EditComment extends StatefulWidget {
  EditComment({
    Key? key,
    required this.text,
    required this.image,
    required this.commentImage,
    required this.petId,
    required this.postId,
    required this.id,
  }) : super(key: key);
  final String image;
  final String text;
  String? commentImage;
  final String id;
  final String postId;
  final dynamic petId;

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  String url = 'http://squeak101-001-site1.itempurl.com/files/';
  var commentController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    commentController.text = widget.text;
    print(commentController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentCubit(),
      child: BlocConsumer<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is UpdateCommentSuccess) {
            if (MainCubit.get(context).modelImage != null) {
              MainCubit.get(context).modelImage = null;
              CommentCubit.get(context).commentImage = null;
            }

            commentController.clear();
            navigateAndFinish(
              context,
              CommentScreen(
                postId: widget.postId,
                isAppBar: true,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = CommentCubit.get(context);
          bool isReplayCommentOpen = CacheHelper.getBool('isReplayCommentOpen');
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).editComment.substring(0, 13)),
              actions: [
                IconButton(
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
                                  .then((value) {
                                cubit.updateComment(
                                  postId: widget.postId,
                                  commentId: widget.id,
                                  content: commentController.text,
                                  petId: CacheHelper.getData('isPet') == true
                                      ? CacheHelper.getData('activeId')
                                      : null,
                                  image:
                                      MainCubit.get(context).modelImage!.data!,
                                  parentId: isReplayCommentOpen
                                      ? CacheHelper.getData('replayCommentID')
                                      : null,
                                );
                              });
                            } else {
                              cubit.updateComment(
                                postId: widget.postId,
                                commentId: widget.id,
                                content: commentController.text,
                                petId: CacheHelper.getData('isPet') == true
                                    ? CacheHelper.getData('activeId')
                                    : null,
                                image: widget.commentImage,
                                parentId: isReplayCommentOpen
                                    ? CacheHelper.getData('replayCommentID')
                                    : null,
                              );
                            }
                          }
                        },
                  icon: cubit.isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(IconlyLight.paper_upload),
                ),
              ],
            ),
            body: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return '';
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: commentController,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // if (widget.commentImage != '' || cubit.commentImage != null)
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Stack(
                  //       alignment: AlignmentDirectional.topEnd,
                  //       children: [
                  //         Container(
                  //           width: double.infinity,
                  //           height: 500,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(
                  //               4.0,
                  //             ),
                  //             image: DecorationImage(
                  //               image:
                  //                   CommentCubit.get(context).commentImage == null
                  //                       ? NetworkImage(
                  //                           '$imageUrl${widget.commentImage}')
                  //                       : FileImage(CommentCubit.get(context)
                  //                           .commentImage!) as ImageProvider,
                  //             ),
                  //           ),
                  //         ),
                  //         IconButton(
                  //           icon: const CircleAvatar(
                  //             radius: 20.0,
                  //             child: Icon(
                  //               Icons.close,
                  //               size: 16.0,
                  //             ),
                  //           ),
                  //           onPressed: () {
                  //             MainCubit.get(context).modelImage = null;
                  //             widget.commentImage = '';
                  //             CommentCubit.get(context).removePostImage();
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
