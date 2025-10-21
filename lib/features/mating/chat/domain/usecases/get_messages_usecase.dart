import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/message_entity.dart';
import 'parameters.dart';

class GetMessagesUseCase extends BaseUseCase<List<MessageEntity>, GetMessagesParameters> {
  final BaseChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(GetMessagesParameters parameters) async {
    return await repository.getMessages(parameters.chatId);
  }
}