import 'package:dartz/dartz.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';
import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';

abstract class BaseChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getChats(String petId);
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId, {
    int pageNumber = 1,
  });
  Future<Either<Failure, MessageEntity>> sendMessage(
    SendMessageParameters parameters,
  );
  Future<Either<Failure, void>> finishMating(FinishMatingParameters matingId);
  Future<Either<Failure, bool>> blockChat(BlockChatParameters params);
  Future<Either<Failure, bool>> renameChat(RenameChatParameters params);
  Future<Either<Failure, bool>> rateMating(RateMatingParameters params);
  Future<Either<Failure, bool>> clearChat(ClearChatParameters params);
  Future<Either<Failure, bool>> deleteMessage(DeleteMessageParameters params);
}
