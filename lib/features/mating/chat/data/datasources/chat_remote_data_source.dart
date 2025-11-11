import 'package:dio/dio.dart';

import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/network/end_points.dart' as endpoints;
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class BaseChatRemoteDataSource {
  Future<List<ChatModel>> getChats(petId);
  Future<List<MessageModel>> getMessages(String chatId);
  Future<MessageModel> sendMessage(SendMessageParameters parameters);
  Future<void> finishMating(FinishMatingParameters matingId);
  Future<bool> renameChat(RenameChatParameters param);
  Future<bool> blockChat(BlockChatParameters param);
  Future<bool> ratingMating(RateMatingParameters param);
  Future<bool> clearChat(ClearChatParameters param);
  Future<bool> deleteMessage(DeleteMessageParameters param);
}

class ChatRemoteDataSource implements BaseChatRemoteDataSource {
  @override
  Future<List<ChatModel>> getChats(petId) async {
    try {
      final response = await DioFinalHelper.getData(
        method: getChatsEndPoint(petId),
      );
      return (response.data['data'] as List)
          .map((chat) => ChatModel.fromJson(chat))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final response = await DioFinalHelper.getData(
        method: getMSGChatsEndPoint(chatId),
      );
      return (response.data['data']['messageDtos'] as List)
          .map((chat) => MessageModel.fromJson(chat))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<MessageModel> sendMessage(SendMessageParameters parameters) async {
    try {
      final response = await DioFinalHelper.postData(
        method: sendMSGEndPoint,
        data: parameters.toJson(),
      );
      return MessageModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<void> finishMating(FinishMatingParameters matingId) async {
    try {
      final response = await DioFinalHelper.putData(
        method: finishMatingRequestsEndPoint,
        data: matingId.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<bool> renameChat(RenameChatParameters param) async {
    try {
      final response = await DioFinalHelper.putData(
        method: renameChatEndPoint,
        data: param.toJson(),
      );
      return response.data['success'];
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<bool> blockChat(BlockChatParameters param) async {
    try {
      final response = await DioFinalHelper.putData(
        method: blockChatEndPoint,
        data: param.toJson(),
      );
      return response.data['success'];
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }

  @override
  Future<bool> ratingMating(RateMatingParameters param) async {
    try {
      final response = await DioFinalHelper.putData(
        method: rateMatingEndPoint,
        data: param.toJson(),
      );
      return response.data['success'];
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }
  
  @override
  Future<bool> clearChat(ClearChatParameters param)async {
    try {
      final url = clearChatEndPoint(param.conversationId, deleteForMeOnly: param.onlyFromMe);
      final response = await DioFinalHelper.deleteData(
        method: url,
      );
      return response.data['success'];
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }
  
  @override
  Future<bool> deleteMessage(DeleteMessageParameters param)async {
    try {
      final url = endpoints.deleteMessage(param.conversationId, param.messageId, param.onlyFromMe);
      final response = await DioFinalHelper.deleteData(
        method: url,
      );
      return response.data['success'];
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response?.data),
      );
    }
  }


}
