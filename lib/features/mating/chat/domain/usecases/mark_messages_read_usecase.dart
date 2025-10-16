import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';
import 'parameters.dart';

class MarkMessagesReadUseCase extends BaseUseCase<void, MarkMessagesReadParameters> {
  final BaseChatRepository repository;

  MarkMessagesReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkMessagesReadParameters parameters) async {
    return await repository.markMessagesAsRead(parameters.chatId);
  }
}