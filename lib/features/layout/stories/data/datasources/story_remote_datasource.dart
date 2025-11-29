import 'package:dio/dio.dart';
import 'package:squeak/features/layout/stories/domain/repositories/story_repository.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/network/dio.dart';
import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error_message_model.dart';
import '../models/story_model.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> fetchActiveStories();
  Future<StoryModel> uploadAndCreateStory(CreateStoryParams story);
}

class StoryRemoteDataSourceMock implements StoryRemoteDataSource {
  @override
  Future<List<StoryModel>> fetchActiveStories() async {
    try {
      Response result = await DioFinalHelper.getData(
        method: getStoryEndPoint,
        language: true,
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
  Future<StoryModel> uploadAndCreateStory(CreateStoryParams story) async {
    try {
      Response result = await DioFinalHelper.postData(
        method: createStoryEndPoint,
        data: story.toJson(),
      );
      return StoryModel.fromJson(result.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
