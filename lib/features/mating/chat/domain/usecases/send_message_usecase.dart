import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/message_entity.dart';
import 'parameters.dart';


class SendMessageUseCase extends BaseUseCase<MessageEntity, SendMessageParameters> {
  final BaseChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParameters parameters) async {
    return await repository.sendMessage(parameters);
  }
}