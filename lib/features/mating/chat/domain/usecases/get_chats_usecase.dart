import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/chat_entity.dart';

class GetChatsUseCase extends BaseUseCase<List<ChatEntity>, String> {
  final BaseChatRepository repository;

  GetChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(String parameters) async {
    return await repository.getChats(parameters);
  }
}
