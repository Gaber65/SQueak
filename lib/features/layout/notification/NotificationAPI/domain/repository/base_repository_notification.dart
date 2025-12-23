import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';

import '../../../../post/domain/entities/post_entity.dart';
import '../entities/notification_entities.dart';

abstract class BaseNotificationRepository {
  Future<Either<Failure, List<NotificationEntities>>> getAllNotifications(
    String petId,
  );
  Future<Either<Failure, void>> updateNotificationState(String id);

  Future<Either<Failure, List<PostEntity>>> getPostNotification(String postId);
}
