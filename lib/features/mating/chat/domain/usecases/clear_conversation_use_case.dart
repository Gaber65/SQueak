import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';

import '../repositories/chat_repository.dart';
import 'parameters.dart';

class ClearConversationUseCase {
  final BaseChatRepository repository;

  ClearConversationUseCase(this.repository);

  Future<Either<Failure, bool>> call(ClearChatParameters params) {
    return repository.clearChat(params);
  }
}
