import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/exception.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/react_entities.dart';
import '../../domain/repo/base_react_repo.dart';
import '../source/react_date_source.dart';

class ReactRepo implements BaseReactRepo {
  final ReactDataSource reactDataSource;

  ReactRepo(this.reactDataSource);

  @override
  Future<Either<Failure, ReactionSummary>> getAllReactOnPost(
    String postId,
  ) async {
    try {
      final result = await reactDataSource.getAllReactOnPost(postId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, ReactionActionResult>> reactOnPost(
    ReactParams params,
  ) async {
    try {
      final r = await reactDataSource.reactOnPost(params);
      return Right(r);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
