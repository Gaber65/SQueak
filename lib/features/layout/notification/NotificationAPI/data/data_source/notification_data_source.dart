import 'package:dio/dio.dart';

import '../../../../../../core/utils/export_path/export_files.dart';
import '../../../../post/data/model/post_model.dart';
import '../model/notification_model.dart';

abstract class BaseNotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String id);
  Future<void> updateNotificationState(String id);

  Future<List<PostDataModel>> getPostNotification(String postId);
}

class NotificationRemoteDataSource extends BaseNotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications(String id) async {
    try {
      Response response = await DioFinalHelper.getData(
        method:
            id.isNotEmpty
                ? '$version/notifications/pet/$id'
                : '$version/notifications',
        language: true,
      );
      return (id.isNotEmpty
              ? response.data['data']['notifications'] as List
              : response.data['data']['notificationDtos'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> updateNotificationState(String id) async {
    try {
      await DioFinalHelper.putData(
        method: '$version/notifications/$id',
        data: {},
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<List<PostDataModel>> getPostNotification(String postId) async {
    try {
      Response result = await DioFinalHelper.getData(
        method: createPostEndPoint(postId),
        language: true,
      );
      return (result.data['data']['posts'] as List)
          .map((e) => PostDataModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
