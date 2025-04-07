import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/features/layout/models/post_model.dart';

import '../../../../core/constant/global_function/global_function.dart';
import '../../../../core/helper/remotely/dio.dart';
import '../../../../core/helper/remotely/end-points.dart';
import 'package:intl/intl.dart';

part 'feeds_state.dart';

class FeedsCubit extends Cubit<FeedsState> {
  FeedsCubit() : super(FeedsInitial());

  static FeedsCubit get(context) => BlocProvider.of(context);

  int allPostUserPageNumber = 1;
  List<Posts> userPosts = [];
  List<Posts> userPostsModel = [];

  void sortUserPostsByDate() {
    final dateFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss zzz', 'en_US');

    userPosts.sort((a, b) {
      DateTime dateA = dateFormat.parse(a.createdAt);
      DateTime dateB = dateFormat.parse(b.createdAt);
      return dateB.compareTo(dateA); // Sort in descending order (newest first)
    });
    emit(GetPostLoadingState());
  }

  void init() {
    if (CacheHelper.getData('posts') != null) {
      String stringToJson = CacheHelper.getData('posts');
      dynamic postsJson = json.decode(stringToJson);
      userPosts = List<Posts>.from(postsJson.map((x) => Posts.fromJson(x)));
      sortUserPostsByDate();
    }
    getAllUserPosts();
  }

  Future<void> getAllUserPosts({
    bool pagination = false,
  }) async {
    if (pagination) {
      emit(PaginationLoadingState());
    } else {
      emit(GetPostLoadingState());
    }

    try {
      final result = await DioFinalHelper.getData(
        method: getPostEndPoint(allPostUserPageNumber),
        language: true,
      );
      List<dynamic> sortedData = result.data['data']['result'] as List<dynamic>;
      sortedData.sort((a, b) {
        final createdAtA = a['createdAt'];
        final createdAtB = b['createdAt'];
        return createdAtB.compareTo(createdAtA);
      });
      String jsonToString = json.encode(sortedData);
      CacheHelper.saveData('posts', jsonToString);
      PostModel postModel = PostModel.fromJson(result.data);
      _handlePostSuccess(postModel);
    } on DioException catch (e) {
      _handlePostError(
        e,
      );
    }
  }

  void _handlePostSuccess(PostModel postModel) {
    print(postModel.message);

    allPostUserPageNumber++;

    userPostsModel.clear();
    userPostsModel.addAll(postModel.posts);

    if (userPostsModel.isNotEmpty) {
      Set<String> existingPostIds =
          userPosts.map((post) => post.postId).toSet();
      bool listsEqual = true;
      for (var post in userPostsModel) {
        if (!existingPostIds.contains(post.postId)) {
          listsEqual = false;
          userPosts.add(post);
          sortUserPostsByDate();
        }
      }

      if (listsEqual) {
        print('equal');
      } else {
        print('not equal');
        print(userPosts.length);
      }

      emit(GetPostSuccessState(postModel));
    } else {
      emit(PaginationErrorState());
    }
  }

  void _handlePostError(
    DioException e,
  ) {
    String stringToJson = CacheHelper.getData('posts')!;
    dynamic postsJson = json.decode(stringToJson);

    Map<String, dynamic> toJson = {
      'success': false,
      'errors': {},
      'data': postsJson,
      'message': isArabic()
          ? "خطأ في الشبكة. الرجاء التحقق من اتصال الانترنت الخاص بك."
          : 'Network error. Please check your internet connection.',
      'statusCode': 000,
    };

    if (e.error.toString().contains('SocketException')) {
      PostModel postDoctorModel = PostModel.fromJson(toJson);

      _handlePostSuccess(postDoctorModel);
    } else {
      print('Error response: ${e.response!.data}');
      emit(GetPostErrorState());
    }
  }

  Future<void> handleRefresh() async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        allPostUserPageNumber = 1;
        getAllUserPosts();
      },
    );
    emit(GetRefreshIndicatorState());
  }
}
