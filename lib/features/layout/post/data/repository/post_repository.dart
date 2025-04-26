import 'package:dartz/dartz.dart';

import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/layout/post/domain/entities/post_entity.dart';
import 'package:squeak/features/layout/post/domain/repository/base_post_repository.dart';

import '../../../../../core/error/exception.dart';
import '../data_source/post_data_source.dart';

class PostRepository extends BasePostRepository {
  final BasePostRemoteDataSource basePostRemoteDataSource;

  PostRepository(this.basePostRemoteDataSource);

  @override
  Future<Either<Failure, List<PostEntity>>> getAllUserPosts(
    int allPostUserPageNumber,
  ) async {
    final result = await basePostRemoteDataSource.getPostDataSource(
      allPostUserPageNumber,
    );

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.message));
    }
  }

}
