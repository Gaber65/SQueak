import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service/cache/shared_preferences/cache_helper.dart'
    show CacheHelper;
import '../../../../core/service/global_function/format_utils.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repository/base_comment_repository.dart';
import '../../domain/usecase/create_comment_use_case.dart';
import '../../domain/usecase/delete_comment_use_case.dart';
import '../../domain/usecase/get_comment_use_case.dart';
import '../../domain/usecase/update_comment_use_case.dart';
import 'package:intl/intl.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit(
    this.deleteCommentPostUseCase,
    this.updateCommentUseCase,
    this.getCommentPostUseCase,
    this.createCommentUseCase,
  ) : super(CommentInitial());

  static CommentCubit get(context) => BlocProvider.of(context);

  File? commentImage;
  void removeCommentImage() async {
    commentImage = null;
    emit(CommentRemovePostImageState());
  }

  CreateCommentUseCase createCommentUseCase;
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
    final userId = CacheHelper.getData('clintId');

    final result = await createCommentUseCase(
      CreateCommentParameters(
        content: content,
        image: image,
        user: userId!,
        petId: petId,
        postId: postId,
        parentId: parentId,
      ),
    );

    result.fold(
      (error) {
        isLoading = false;
        emit(CreateCommentError());
      },
      (newComment) {
        if (isArabic()) {
          getComment(postId: postId);
        } else {
          _addCommentToList(newComment, parentId);
        }
        isLoading = false;

        emit(CreateCommentSuccess());
      },
    );
  }

  void _addCommentToList(CommentEntity comment, String? parentId) {
    if (parentId == null) {
      comments.add(comment);
      comments.sort((a, b) {
        final dateFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss zzz', 'en_US');
        DateTime dateA = dateFormat.parse(a.createdAt);
        DateTime dateB = dateFormat.parse(b.createdAt);
        return dateB.compareTo(dateA);
      });
    } else {
      final parent = comments.firstWhere((e) => e.id == parentId);
      parent.replies.add(comment);
      parent.replies.sort((a, b) {
        final dateFormat = DateFormat('EEE MMM dd yyyy HH:mm:ss zzz', 'en_US');
        DateTime dateA = dateFormat.parse(a.createdAt);
        DateTime dateB = dateFormat.parse(b.createdAt);
        return dateB.compareTo(dateA);
      });
    }
  }

  UpdateCommentUseCase updateCommentUseCase;
  Future<void> updateComment({
    required String commentId,
    required String postId,
    required String content,
    required String? petId,
    required String? image,
    required String? parentId,
  }) async {
    emit(UpdateCommentLoading());
    final result = await updateCommentUseCase(
      CreateCommentParameters(
        content: content,
        image: image,
        user: CacheHelper.getData('clintId')!,
        petId: petId,
        postId: postId,
        commentId: commentId,
        parentId: parentId,
      ),
    );
    result.fold(
      (l) => emit(UpdateCommentError()),
      (r) => emit(UpdateCommentSuccess()),
    );
  }

  DeleteCommentPostUseCase deleteCommentPostUseCase;
  Future<void> deleteComment({
    required String commentId,
    required List<CommentEntity> replies,
  }) async {
    emit(DeleteCommentLoading());

    final result = await deleteCommentPostUseCase(
      CreateCommentParameters(commentId: commentId),
    );

    result.fold((_) => emit(DeleteCommentError()), (_) async {
      for (final reply in replies) {
        await deleteComment(commentId: reply.id, replies: reply.replies);
      }

      _removeCommentById(commentId);
      emit(DeleteCommentSuccess());
    });
  }

  void _removeCommentById(String commentId) {
    comments =
        comments.where((comment) => comment.id != commentId).map((comment) {
          final updatedReplies =
              comment.replies.where((reply) => reply.id != commentId).toList();
          return comment.copyWith(replies: updatedReplies);
        }).toList();
  }

  GetCommentPostUseCase getCommentPostUseCase;
  List<CommentEntity> comments = [];
  Future<void> getComment({required String postId}) async {
    emit(GetCommentLoading());
    final result = await getCommentPostUseCase(
      CreateCommentParameters(postId: postId),
    );
    result.fold((l) => emit(GetCommentError()), (r) {
      comments = r;
      comments.removeWhere((element) => element.parentId != null);
      emit(GetCommentSuccess(r));
    });
  }

  @override
  Future<void> close() async {
    await CacheHelper.saveData('isReplayCommentOpen', false);
    super.close();
  }
}
