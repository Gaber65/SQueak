part of 'comment_cubit.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

///todo picked image
class CommentImagePickedErrorState extends CommentState {}
class CommentRemovePostImageState extends CommentState {}
class CommentImagePickedSuccessState extends CommentState {
  File file ;
  CommentImagePickedSuccessState(this.file);
}

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
class GetCommentSuccess extends CommentState {}
class GetCommentError extends CommentState {}

class GetPostLoading extends CommentState {}
class GetPostSuccess extends CommentState {}
class GetPostError extends CommentState {}

class GetCommentRepliesLoading extends CommentState {}
class GetCommentRepliesSuccess extends CommentState {
  List<Comments> commentEntities;

  GetCommentRepliesSuccess(this.commentEntities);
}
class GetCommentRepliesError extends CommentState {}

class IsBottomSheetOpen extends CommentState {}