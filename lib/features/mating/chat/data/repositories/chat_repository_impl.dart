import 'package:dartz/dartz.dart';
import 'package:squeak/features/mating/chat/data/datasources/chat_remote_data_source.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/domain/repositories/chat_repository.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/parameters.dart';


class ChatRepository implements BaseChatRepository {
  final BaseChatRemoteDataSource remoteDataSource;

  ChatRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      final chats = await remoteDataSource.getChats();
      return Right(chats);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getChatsByStatus(ChatStatus status) async {
    try {
      final chats = await remoteDataSource.getChats();
      final filteredChats = chats.where((chat) => chat.status == status).toList();
      return Right(filteredChats);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String chatId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return Right(messages);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(SendMessageParameters parameters) async {
    try {
      final message = await remoteDataSource.sendMessage(parameters);
      return Right(message);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> updateChatStatus(String chatId, ChatStatus status) async {
    try {
      await remoteDataSource.updateChatStatus(chatId, status);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(String chatId) async {
    try {
      await remoteDataSource.markMessagesAsRead(chatId);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}