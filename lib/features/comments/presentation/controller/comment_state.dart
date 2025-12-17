part of 'comment_cubit.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentRemovePostImageState extends CommentState {}

///todo Create Comment
class CreateCommentLoading extends CommentState {}

class CreateCommentSuccess extends CommentState {}

class CreateCommentError extends CommentState {}

///todo Update Comment
class UpdateCommentLoading extends CommentState {}

class UpdateCommentSuccess extends CommentState {}

class UpdateCommentError extends CommentState {}

///todo Delete Comment
class DeleteCommentLoading extends CommentState {}

class DeleteCommentSuccess extends CommentState {}

class DeleteCommentError extends CommentState {}

///todo Get Comment
class GetCommentLoading extends CommentState {}

class GetCommentSuccess extends CommentState {
  List<CommentEntity> commentEntities;

  GetCommentSuccess(this.commentEntities);
}

class GetCommentError extends CommentState {}

class IsBottomSheetOpen extends CommentState {}
