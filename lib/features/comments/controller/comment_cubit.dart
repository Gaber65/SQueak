import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/features/layout/models/post_model.dart';

import '../../../core/helper/cache/cache_helper.dart';
import '../../../core/helper/remotely/dio.dart';
import '../../../core/helper/remotely/end-points.dart';
import '../models/get_comment_post.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  static CommentCubit get(context) => BlocProvider.of(context);

  File? commentImage;
  var picker = ImagePicker();

  Future<void> getPostCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(CommentImagePickedSuccessState(commentImage!));
    } else {
      debugPrint('No image selected.');
      emit(CommentImagePickedErrorState());
    }
  }

  void removePostImage() async {
    commentImage = null;
    emit(CommentRemovePostImageState());
  }

  bool isLoading = false;

  Future<void> createComment({
    required String postId,
    required String content,
    String? petId,
    String? image,
    String? parentId,
  }) async {
    isLoading = true;
    emit(CreateCommentLoading());

    try {
      Response result = await DioFinalHelper.postData(
        method: createCommentEndPoint,
        data: {
          "postId": postId,
          "content": content,
          "petId": petId,
          // "image": image,
          "parentId": parentId,
        },
      );

      var model = Comments.fromJson(result.data['data']);
      isLoading = false;

      if (isArabic()) {
        getComment(postId: postId);
        emit(CreateCommentSuccess());
      } else {
        if (parentId == null) {
          comments.add(model);
          comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        } else {
          comments
              .firstWhere((element) => element.id == parentId)
              .replies
              .add(model);
          comments.firstWhere((element) => element.id == parentId).replies
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
        emit(CreateCommentSuccess());
      }
    } on DioException catch (e) {
      print(e.response!.data);
      isLoading = false;
      emit(CreateCommentError());
    }
  }

  Future<void> updateComment({
    required String commentId,
    required String postId,
    required String content,
    required String? petId,
    required String? image,
    required String? parentId,
  }) async {
    isLoading = true;
    emit(UpdateCommentLoading());

    try {
      Response result = await DioFinalHelper.patchData(
        method: updateCommentEndPoint,
        data: {
          "postId": postId,
          "content": content,
          "petId": petId,
          "id": commentId,
          // "image": image,
          "parentId": parentId,
        },
      );

      print(result.data);
      isLoading = false;
      emit(UpdateCommentSuccess());
    } on DioException catch (e) {
      print(e.response!.data);
      isLoading = false;
      emit(UpdateCommentError());
    }
  }

  Future<void> deleteComment({
    required String commentId,
    required List<Comments> replies,
  }) async {
    emit(DeleteCommentLoading());

    try {
      // Recursively delete all replies first
      for (var reply in replies) {
        await deleteComment(
          commentId: reply.id,
          replies: reply.replies,
        );
      }

      await DioFinalHelper.deleteData(
        method: deleteCommentEndPoint + commentId,
      );

      comments =
          comments.where((comment) => comment.id != commentId).map((comment) {
        comment.replies = comment.replies
            .where((r) => r.id != commentId)
            .toList(); // Remove nested replies
        return comment;
      }).toList();

      emit(DeleteCommentSuccess());
    } on DioException catch (e) {
      print(e.response?.data ?? 'Unknown DioError');
      emit(DeleteCommentError());
    } catch (e) {
      print('Unexpected error: $e');
      emit(DeleteCommentError());
    }
  }

  List<Comments> comments = [];

  Future<void> getComment({
    required String postId,
  }) async {
    emit(GetCommentLoading());
    print(postId);

    try {
      Response result = await DioFinalHelper.getData(
        method: getCommentEndPoint + postId,
        language: true,
      );
      comments = (result.data['data']['comments'] as List)
          .map((e) => Comments.fromJson(e))
          .toList();
      comments.removeWhere((element) => element.parentId != null);
      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(GetCommentSuccess());
    } on DioException catch (e) {
      print(e.response!.data);
      emit(GetCommentError());
    }
  }

  List<Posts> post = [];
  Posts? postModel;
  bool isLoadingPost = false;
  Future getPost({required String postId}) async {
    isLoadingPost = true;
    emit(GetPostLoading());
    try {
      Response result = await DioFinalHelper.getData(
        method: createPostEndPoint(postId),
        language: true,
      );

      post = (result.data['data']['posts'] as List)
          .map((e) => Posts.fromJson(e))
          .toList();

      if (post.any((element) => element.postId == postId)) {
        postModel = post.firstWhere((element) => element.postId == postId);
        print('Post found: $postModel');
      } else {
        emit(GetPostError());
      }
      isLoadingPost = false;
      emit(GetPostSuccess());
    } on DioException catch (e) {
      isLoadingPost = false;
      print(e.response!.data);
      emit(GetPostError());
    }
  }

  @override
  Future<void> close() {
    print('close Cubit');
    CacheHelper.removeData('NotificationId');
    CacheHelper.removeData('NotificationType');

    return super.close();
  }
}
