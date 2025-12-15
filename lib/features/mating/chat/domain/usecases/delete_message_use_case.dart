import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/mating/chat/domain/repositories/chat_repository.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';

class DeleteMessageUseCase {
  final BaseChatRepository repository;

  DeleteMessageUseCase(this.repository);

  Future<Either<Failure, bool>> call(DeleteMessageParameters params) {
    return repository.deleteMessage(params);
  }
}
