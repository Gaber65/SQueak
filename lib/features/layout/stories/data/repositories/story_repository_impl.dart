import 'package:dartz/dartz.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/paginated_reactions_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_remote_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;

  StoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createStory(CreateStoryParams params) async {
    try {
      final result = await remoteDataSource.createStory(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteStory(String storyId) async {
    try {
      final result = await remoteDataSource.deleteStory(storyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getMyActiveStories(
    String petId,
  ) async {
    try {
      final result = await remoteDataSource.getMyActiveStories(petId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<FrindStoryEntity>>> getFriendsStories(
    String petId,
  ) async {
    try {
      final result = await remoteDataSource.getFriendsStories(petId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, PaginatedReactionsEntity>> getStoryReactions({
    required String userStoryId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final result = await remoteDataSource.getStoryReactions(
        userStoryId: userStoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> reactToStory(ReactToStoryParams params) async {
    try {
      final result = await remoteDataSource.reactToStory(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<StoryEntity>>> getAllFriendStories(
    String petId,
  ) async {
    try {
      final result = await remoteDataSource.getAllFriendStories(petId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, String>> sendReplyMsgToStoryPet(
    SendReplyMsgToStoryPetParams params,
  ) async {
    try {
      final result = await remoteDataSource.sendReplyMsgToStoryPet(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }
}
