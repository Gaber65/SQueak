import 'package:dartz/dartz.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/parameters.dart';

class ChatRepository implements BaseChatRepository {
  final BaseChatRemoteDataSource remoteDataSource;

  ChatRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats(parameters) async {
    try {
      final chats = await remoteDataSource.getChats(parameters);
      return Right(chats);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }


  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId,
  ) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return Right(messages);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
    SendMessageParameters parameters,
  ) async {
    try {
      final message = await remoteDataSource.sendMessage(parameters);
      return Right(message);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> finishMating(
    FinishMatingParameters matingId,
  ) async {
    try {
      final result = await remoteDataSource.finishMating(matingId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> blockChat(
    BlockChatParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.blockChat(parameters);
      return  Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> renameChat(RenameChatParameters params) async {
    try {
      final result = await remoteDataSource.renameChat(params);
      return  Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> rateMating(RateMatingParameters params) async {
    try {
      final result = await remoteDataSource.ratingMating(params);
      return  Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

}
