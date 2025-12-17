import 'package:dartz/dartz.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';

class RenameChatUseCase extends BaseUseCase<bool, RenameChatParameters> {
  final BaseChatRepository repository;

  RenameChatUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(RenameChatParameters parameters) async {
    return await repository.renameChat(parameters);
  }
}
