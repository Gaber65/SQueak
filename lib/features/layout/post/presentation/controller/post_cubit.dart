import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

import '../../domain/entities/post_entity.dart';
import 'package:intl/intl.dart';

import '../../domain/usecase/create_post.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetAllPostUseCase getAllPostUseCase;
  final CreatePostUseCase createPostUseCase;

  PostCubit(this.getAllPostUseCase, this.createPostUseCase)
    : super(PostInitial());
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
      (posts) => _handlePostSuccess(posts,pagination: pagination),
    );
  }

  void _handlePostSuccess(Iterable<PostEntity> posts,{bool pagination = false}) {
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
      if(!pagination){
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

  Future<void> createPost(
    String petId,
    String title,
    String content,
    String? image,
    String? video,
  ) async {
    emit(CreatePostLoadingState());

    final result = await createPostUseCase(
      CreatePostParams(
        petId: petId,
        content: content,
        title: title,
        postSocailMedias: [
          {'image': image, 'video': video},
        ],
      ),
    );

    result.fold(
      (failure) =>
          emit(CreatePostErrorState(extractFirstErrorAuth(failure.error))),
      (post) => emit(CreatePostSuccessState()),
    );
  }
  Future<void> createPostWithMultipleMedia({
    required String petId,
    required String title,
    required String content,
    required List<Map<String, String?>> postSocialMedias,
  }) async {
    emit(CreatePostLoadingState());

    try {
      final result = await createPostUseCase(
        CreatePostParams(
          petId: petId,
          content: content,
          title: title,
          postSocailMedias: postSocialMedias,
        ),
      );

      result.fold(
            (failure) => emit(CreatePostErrorState(extractFirstErrorAuth(failure.error))),
            (post) {
          emit(CreatePostSuccessState());
        },
      );
    } catch (e) {
      emit(CreatePostErrorState('Failed to create post: $e'));
    }
  }

  void clearUserPosts() {
    _pageNumber = 1;
    _userPosts.clear();
    emit(GetPostSuccessState()); // أو أي state مناسب بعد المسح
  }

  bool isClick = false;
  void changeClick(){
    isClick = !isClick;
    emit(NoInternetConnection());
  }
}
