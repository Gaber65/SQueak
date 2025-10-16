import 'package:dartz/dartz.dart';

import '../../../../../../core/utils/export_path/export_files.dart';
import '../../../../post/data/model/post_model.dart';
import '../../domain/entities/notification_entities.dart' show NotificationEntities;
import '../../domain/repository/base_repository_notification.dart';
import '../data_source/notification_data_source.dart';

class NotificationRepository extends BaseNotificationRepository {
  final BaseNotificationRemoteDataSource baseNotificationRemoteDataSource;

  NotificationRepository(this.baseNotificationRemoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntities>>>
  getAllNotifications() async {
    try {
      final result = await baseNotificationRemoteDataSource.getNotifications();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationState(String id) async {
    try {
      await baseNotificationRemoteDataSource.updateNotificationState(id);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<PostDataModel>>> getPostNotification(
    String postId,
  ) async {
    try {
      final result = await baseNotificationRemoteDataSource.getPostNotification(
        postId,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
