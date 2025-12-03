import 'package:dio/dio.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/network/dio.dart';
import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error_message_model.dart';
import '../../domain/repositories/story_repository.dart';
import '../models/story_model.dart';
import '../models/paginated_reactions_model.dart';

abstract class StoryRemoteDataSource {
  Future<String> createStory(CreateStoryParams params);
  Future<bool> deleteStory(String storyId);
  Future<List<StoryModel>> getMyActiveStories(String petId);
  Future<List<FrindStoryModel>> getFriendsStories(String petId);
  Future<List<StoryModel>> getAllFriendStories(String petId);
  Future<PaginatedReactionsModel> getStoryReactions({
    required String userStoryId,
    required int pageNumber,
    required int pageSize,
  });
  Future<bool> reactToStory(ReactToStoryParams params);

  Future<String> sendReplyMsgToStoryPet(SendReplyMsgToStoryPetParams params);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  @override
  Future<String> createStory(CreateStoryParams params) async {
    try {
      final result = await DioFinalHelper.postData(
        method: createStoryEndPoint,
        data: params.toJson(),
      );
      return result.data['message'] ?? '';
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<bool> deleteStory(String storyId) async {
    try {
      await DioFinalHelper.deleteData(method: '$deleteStoryEndPoint$storyId');
      return true;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<StoryModel>> getMyActiveStories(String petId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: "$myActiveStoriesEndPoint?PetId=$petId",
      );
      return (result.data['data']['result'] as List)
          .map((e) => StoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<FrindStoryModel>> getFriendsStories(String petId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: "$friendsStoriesEndPoint?PetId=$petId",
      );
      return (result.data['data']['result'] as List)
          .map((e) => FrindStoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<PaginatedReactionsModel> getStoryReactions({
    required String userStoryId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final result = await DioFinalHelper.getData(
        method: getStoryReactionsEndPoint,
        query: {
          'UserStoryId': userStoryId,
          'PageNumber': pageNumber,
          'PageSize': pageSize,
        },
      );
      return PaginatedReactionsModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<bool> reactToStory(ReactToStoryParams params) async {
    try {
      await DioFinalHelper.postData(
        method: reactToStoryEndPoint,
        data: params.toJson(),
      );
      return true;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<StoryModel>> getAllFriendStories(String petId) async {
    try {
      final result = await DioFinalHelper.getData(
        method: allFriendStoriesEndPoint(petId),
      );
      return (result.data['data'] as List)
          .map((e) => StoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<String> sendReplyMsgToStoryPet(
    SendReplyMsgToStoryPetParams params,
  ) async {
    try {
      final result = await DioFinalHelper.postData(
        method: sendReplyMsgToStoryPetEndPoint,
        data: params.toJson(),
      );
      return result.data['message'] ?? '';
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
