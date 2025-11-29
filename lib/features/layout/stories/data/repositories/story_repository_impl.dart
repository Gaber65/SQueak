import 'package:dartz/dartz.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_remote_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remote;

  StoryRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Story>>> getActiveStories() async {
    try {
      final result = await remote.fetchActiveStories();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, Story>> createStory(CreateStoryParams params) async {
    try {
      final result = await remote.uploadAndCreateStory(params);

      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
