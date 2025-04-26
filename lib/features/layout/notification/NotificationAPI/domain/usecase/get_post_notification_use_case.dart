import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../repository/base_repository_notification.dart';

class GetPostNotificationUseCase extends BaseUseCase<List<PostEntity>, String> {
  final BaseNotificationRepository baseNotificationRepository;

  GetPostNotificationUseCase(this.baseNotificationRepository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(String id) async {
    return await baseNotificationRepository.getPostNotification(id);
  }
}
