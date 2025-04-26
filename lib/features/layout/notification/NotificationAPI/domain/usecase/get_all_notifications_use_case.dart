import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../entities/notification_entities.dart';
import '../repository/base_repository_notification.dart';

class GetAllNotificationsUseCase
    extends BaseUseCase<List<NotificationEntities>, NoParameters> {
  final BaseNotificationRepository baseNotificationRepository;

  GetAllNotificationsUseCase(this.baseNotificationRepository);

  @override
  Future<Either<Failure, List<NotificationEntities>>> call(
    NoParameters params,
  ) async {
    return await baseNotificationRepository.getAllNotifications();
  }
}
