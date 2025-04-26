import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../repository/base_repository_notification.dart';

class UpdateNotificationStateUseCase extends BaseUseCase<void, String> {
  final BaseNotificationRepository baseNotificationRepository;

  UpdateNotificationStateUseCase(this.baseNotificationRepository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await baseNotificationRepository.updateNotificationState(id);
  }
}
