import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';
import 'parameters.dart';

class GetChatsUseCase extends BaseUseCase<List<ChatEntity>, GetChatsParameters> {
  final BaseChatRepository repository;

  GetChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(GetChatsParameters parameters) async {
    if (parameters.status != null) {
      return await repository.getChatsByStatus(parameters.status!);
    }
    return await repository.getChats();
  }
}