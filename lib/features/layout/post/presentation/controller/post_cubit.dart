import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/service/cache/shared_preferences/cache_helper.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecase/get_user_posts_use_case.dart';
import 'package:intl/intl.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetAllPostUseCase getAllPostUseCase;
  PostCubit(this.getAllPostUseCase) : super(PostInitial()) {
    init();
  }

  static PostCubit get(context) => BlocProvider.of(context);

  int _pageNumber = 1;
  final List<PostEntity> _userPosts = [];

  List<PostEntity> get userPosts => List.unmodifiable(_userPosts);

  Future<void> init() async {
    _loadCachedPosts();
    await getAllUserPosts();
  }

  void _loadCachedPosts() {
    final cachedData = CacheHelper.getData('posts');
    if (cachedData != null) {
      final postsJson = json.decode(cachedData);
      _userPosts
        ..clear()
        ..addAll(List<PostEntity>.from(postsJson.map((x) => PostEntity.fromJson(x))));
    }
  }

  Future<void> getAllUserPosts({bool pagination = false}) async {
    emit(pagination ? PaginationLoadingState() : GetPostLoadingState());

    final result = await getAllPostUseCase(_pageNumber);
    result.fold(
          (_) => emit(GetPostErrorState()),
          (posts) => _handlePostSuccess(posts),
    );
  }

  void _handlePostSuccess(Iterable<PostEntity> posts) {
    _pageNumber++;

    if (posts.isEmpty) {
      emit(PaginationErrorState());
      return;
    }

    final existingPostIds = _userPosts.map((post) => post.postId).toSet();
    final newPosts = posts.where((post) => !existingPostIds.contains(post.postId)).toList();

    if (newPosts.isNotEmpty) {
      _userPosts.addAll(newPosts);
    }

    final jsonToString = json.encode(_userPosts);
    CacheHelper.saveData('posts', jsonToString);

    emit(GetPostSuccessState());
  }

  // void _sortUserPostsByDate() {
  //   final dateFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss zzz', 'en_US');
  //   _userPosts.sort((a, b) {
  //     final dateA = dateFormat.parse(a.createdAt);
  //     final dateB = dateFormat.parse(b.createdAt);
  //     return dateB.compareTo(dateA);
  //   });
  // }

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _pageNumber = 1;
    await getAllUserPosts();
    emit(GetRefreshIndicatorState());
  }
}
