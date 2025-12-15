import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/comments/domain/entities/comment_entity.dart';

abstract class BaseCommentRepository {
  Future<Either<Failure, CommentEntity>> createComment(
    CreateCommentParameters parameters,
  );

  Future<Either<Failure, CommentEntity>> updateComment(
    CreateCommentParameters parameters,
  );

  Future<Either<Failure, List<CommentEntity>>> getComment(
    CreateCommentParameters parameters,
  );

  Future<Either<Failure, CommentEntity>> deleteComment(
    CreateCommentParameters parameters,
  );
}

class CreateCommentParameters extends Equatable {
  final String? content;
  final String? image;
  final String? user;
  final String? petId;
  final String? postId;
  final String? commentId;
  final String? parentId;
  final List<CommentEntity>? replies;

  const CreateCommentParameters({
    this.content,
    this.image,
    this.user,
    this.petId,
    this.postId,
    this.parentId,
    this.commentId,
    this.replies,
  });

  @override
  List<Object?> get props => [
    content,
    image,
    user,
    petId,
    postId,
    commentId,
    parentId,
    replies,
  ];
}
