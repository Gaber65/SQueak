import 'package:dartz/dartz.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';

class BlockChatUseCase extends BaseUseCase<bool, BlockChatParameters> {
  final BaseChatRepository repository;

  BlockChatUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(BlockChatParameters parameters) async {
    return await repository.blockChat(parameters);
  }
}