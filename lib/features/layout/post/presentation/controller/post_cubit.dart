import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/layout/post/domain/usecase/delete_post_usecase.dart';

import '../../domain/entities/post_entity.dart';
import 'package:intl/intl.dart';

import '../../domain/usecase/create_post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetAllPostUseCase getAllPostUseCase;
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;

  PostCubit(
    this.getAllPostUseCase,
    this.createPostUseCase,
    this.deletePostUseCase,
  ) : super(PostInitial());
  static PostCubit get(context) => BlocProvider.of(context);

  int _pageNumber = 1;
  final List<PostEntity> _userPosts = [];

  List<PostEntity> get userPosts => List.unmodifiable(_userPosts);

  Future<void> getAllUserPosts(String petId, {bool pagination = false}) async {
    emit(pagination ? PaginationLoadingState() : GetPostLoadingState());

    final result = await getAllPostUseCase(
      GetPostParams(
        allPostUserPageNumber: _pageNumber,
        isPet: petId.isNotEmpty,
        petId: petId,
      ),
    );
    result.fold(
      (_) => emit(GetPostErrorState()),
      (posts) => _handlePostSuccess(posts, pagination: pagination),
    );
  }

  void _handlePostSuccess(
    Iterable<PostEntity> posts, {
    bool pagination = false,
  }) {
    _pageNumber++;

    if (posts.isEmpty) {
      emit(PaginationErrorState());
      return;
    }

    final existingPostIds = _userPosts.map((post) => post.postId).toSet();
    final newPosts =
        posts.where((post) => !existingPostIds.contains(post.postId)).toList();

    if (newPosts.isNotEmpty) {
      _userPosts.addAll(newPosts);
      if (!pagination) {
        _sortUserPostsByDate();
      }
    }

    emit(GetPostSuccessState());
  }

  void _sortUserPostsByDate() {
    final dateFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss zzz', 'en_US');
    _userPosts.sort((a, b) {
      final dateA = dateFormat.parse(a.createdAt!);
      final dateB = dateFormat.parse(b.createdAt!);
      return dateB.compareTo(dateA);
    });
  }

  Future<void> handleRefresh(String petId, {bool pagination = false}) async {
    await Future.delayed(const Duration(seconds: 1));
    _pageNumber = 1;
    await getAllUserPosts(petId, pagination: pagination);
    emit(GetRefreshIndicatorState());
  }

  Future<void> createPostWithMultipleMedia({
    required String petId,
    required String title,
    required String content,
    required List<Map<String, String?>> postSocialMedias,
  }) async {
    emit(CreatePostLoadingState());
    final result = await createPostUseCase(
      CreatePostParams(
        id: '',
        petId: petId,
        content: content,
        title: title,
        postSocailMedias: postSocialMedias,
      ),
    );

    result.fold(
      (failure) {
        emit(CreatePostErrorState(extractFirstErrorAuth(failure.error)));
      },
      (post) {
        emit(CreatePostSuccessState());
      },
    );
  }

  Future<void> updatePostWithMultipleMedia({
    required String petId,
    required String id,
    required String title,
    required String content,
    required List<Map<String, String?>> postSocialMedias,
  }) async {
    emit(CreatePostLoadingState());
    final result = await createPostUseCase(
      CreatePostParams(
        id: id,
        petId: petId,
        content: content,
        title: title,
        postSocailMedias: postSocialMedias,
      ),
    );

    result.fold(
      (failure) {
        emit(CreatePostErrorState(extractFirstErrorAuth(failure.error)));
      },
      (post) {
        emit(CreatePostSuccessState());
      },
    );
  }

  Future<void> deletePost(String postId) async {
    emit(DeletePostLoadingState());
    final result = await deletePostUseCase(postId);
    result.fold(
      (failure) {
        emit(DeletePostErrorState(extractFirstErrorAuth(failure.error)));
      },
      (post) {
        _userPosts.removeWhere((post) => post.postId == postId);
        emit(DeletePostSuccessState());
      },
    );
  }

  void clearUserPosts() {
    _pageNumber = 1;
    _userPosts.clear();
    emit(GetPostSuccessState());
  }
}
