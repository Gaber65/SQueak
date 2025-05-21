import 'package:dartz/dartz.dart';

import 'package:squeak/core/error/failure.dart';

import '../../../../core/error/exception.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repository/base_comment_repository.dart';
import '../data_source/comment_data_source.dart';

class CommentRepository extends BaseCommentRepository {
  final BaseCommentRemoteDataSource baseCommentRemoteDataSource;

  CommentRepository(this.baseCommentRemoteDataSource);

  @override
  Future<Either<Failure, CommentEntity>> createComment(
    CreateCommentParameters parameters,
  ) async {
    final result = await baseCommentRemoteDataSource.createCommentDataSource(
      parameters,
    );

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> deleteComment(
    CreateCommentParameters parameters,
  ) async {
    final result = await baseCommentRemoteDataSource.deleteCommentDataSource(
      parameters,
    );

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> updateComment(
    CreateCommentParameters parameters,
  ) async {
    final result = await baseCommentRemoteDataSource.updateCommentDataSource(
      parameters,
    );

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getComment(
    CreateCommentParameters parameters,
  ) async {
    final result = await baseCommentRemoteDataSource.getCommentDataSource(
      parameters,
    );

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
