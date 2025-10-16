import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';
import '../entities/chat_entity.dart';
import '../entities/chat_status.dart';
import '../entities/message_entity.dart';

abstract class BaseChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getChats();
  Future<Either<Failure, List<ChatEntity>>> getChatsByStatus(ChatStatus status);
  Future<Either<Failure, List<MessageEntity>>> getMessages(String chatId);
  Future<Either<Failure, MessageEntity>> sendMessage(SendMessageParameters parameters);
  Future<Either<Failure, void>> updateChatStatus(String chatId, ChatStatus status);
  Future<Either<Failure, void>> markMessagesAsRead(String chatId);
}