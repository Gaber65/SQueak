import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';
import 'parameters.dart';
class UpdateChatStatusUseCase extends BaseUseCase<void, UpdateChatStatusParameters> {
  final BaseChatRepository repository;

  UpdateChatStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateChatStatusParameters parameters) async {
    return await repository.updateChatStatus(parameters.chatId, parameters.status);
  }
}