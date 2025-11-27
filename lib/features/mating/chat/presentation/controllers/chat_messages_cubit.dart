import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/signalr/signalr_service.dart';
import 'package:squeak/features/friendship/domain/entities/send_friend_message_parameters.dart';
import 'package:squeak/features/mating/chat/data/models/message_model.dart';
import 'package:squeak/features/mating/chat/domain/usecases/delete_message_use_case.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/clear_conversation_use_case.dart';
import '../../domain/usecases/parameters.dart';
import '../../domain/usecases/rate_mating_use_case.dart';
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final FinishMatingUseCase startMatingUseCase;
  final BlockChatUseCase blockChatUseCase;
  final RenameChatUseCase renameChatUseCase;
  final RateMatingUseCase rateMatingUseCase;

  ChatMessagesCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.startMatingUseCase,
    required this.blockChatUseCase,
    required this.renameChatUseCase,
    required this.rateMatingUseCase,
  }) : super(ChatMessagesInitial());

  static get(BuildContext context) =>
      BlocProvider.of<ChatMessagesCubit>(context);

  List<MessageEntity> messagesList = [];
  Future<void> loadMessages(String chatId) async {
    if (chatId.isEmpty) {
      emit(ChatMessagesLoaded([]));
      return;
    }

    emit(ChatMessagesLoading());

    final result = await getMessagesUseCase(
      GetMessagesParameters(chatId: chatId),
    );

    result.fold(
      (failure) {
        emit(ChatMessagesError(failure.toString()));
      },
      (messages) {
        messagesList = messages.reversed.toList();
        emit(ChatMessagesLoaded(messages));
      },
    );
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required bool isMe,
    String? fromPetId,
    String? toPetId,
    String? fromUserId,
    String? toUserId,
    String? image,
    String? video,
    String? audio,
  }) async {
    debugPrint('📨 ChatCubit: sendMessage called - Text: "$text", Image: $image, Video: $video, Audio: $audio');
    // Don't emit MessageSending to avoid blocking the UI
    
    bool signalRSuccess = false;
    try {
      final signalRService = SignalRService();
      if (!signalRService.isConnected) {
        await signalRService.connect();
      }
      final messageModel = MessageModel(
        id: '',
        description: text,
        isRead: true,
        fromUserId: fromUserId ?? '',
        toUserId: toUserId ?? '',
        createdAt: DateTime.now(),
        toMe: false,
        image: image,
        video: video,
        audio: audio,
      );

      final command = messageModel.toSignalRCommand(
        conversationId: chatId.isEmpty ? null : chatId,
        fromPetId: fromPetId,
        toPetId: toPetId,
      );

      await signalRService.sendMessageToUser(command);
      debugPrint('✅ Message sent successfully via SignalR');
      
      signalRSuccess = true;
      
      // Reload messages to show the sent message immediately
      if (chatId.isNotEmpty) {
        await loadMessages(chatId);
      }
      
      return; // Exit early on success
    } catch (signalRError) {
      debugPrint('❌ Failed to send message via SignalR: $signalRError');
      debugPrint('🔄 Falling back to REST API...');
    }

    // Fallback to REST API if SignalR failed
    if (!signalRSuccess) {
      if (fromPetId != null && toPetId != null) {
      final friendMessageUseCase = sl<SendFriendMessageUseCase>();

      final result = await friendMessageUseCase(
        SendFriendPetMessageParameters(
          description: text,
          conversationId: chatId.isEmpty ? null : chatId,
          fromPetId: fromPetId,
          toPetId: toPetId,
          isRead: true,
          image: image,
          video: video,
          audio: audio,
        ),
      );

      result.fold(
        (failure) {
          emit(MessageSendError(failure.toString()));
        },
        (response) {
          final message = MessageEntity(
            id: text,
            description: text,
            isRead: true,
            fromUserId: fromPetId,
            toUserId: toPetId,
            createdAt: DateTime.now(),
            toMe: false,
            image: image,
            video: video,
            audio: audio,
          );

          messagesList.add(message);
          emit(MessageSent(message));
        },
      );
      } else {
        final result = await sendMessageUseCase(
          SendMessageParameters(
            description: text,
            conversationId: chatId.isEmpty ? null : chatId,
            fromPetId: fromPetId,
            toPetId: toPetId,
            isRead: true,
            image: image,
            video: video,
            audio: audio,
          ),
        );
        result.fold(
          (failure) {
            emit(MessageSendError(failure.toString()));
          },
          (message) {
            messagesList.add(message);
            emit(MessageSent(message));
          },
        );
      }
    }
  }

  Future<void> finishMating(FinishMatingParameters matingId) async {
    emit(MatingFinish());

    final result = await startMatingUseCase(matingId);

    result.fold((failure) => emit(MatingFinishError(failure.toString())), (
      message,
    ) {
      emit(MatingFinishSuccess());
    });
  }

  Future<bool> blockChat(BlockChatParameters parameters) async {
    emit(BlockChat());

    final result = await blockChatUseCase(parameters);

    final isSuccess = result.fold(
      (failure) {
        emit(BlockChatError(extractFirstErrorAuth(failure.error)));
        return false;
      },
      (message) {
        emit(BlockChatSuccess());
        return true;
      },
    );
    return isSuccess;
  }

  Future<bool> renameChat(RenameChatParameters parameters) async {
    emit(RenameChat());

    final result = await renameChatUseCase(parameters);

    final isSuccess = result.fold(
      (failure) {
        emit(RenameChatError(extractFirstErrorAuth(failure.error)));
        return false;
      },
      (message) {
        emit(RenameChatSuccess());
        return true;
      },
    );
    return isSuccess;
  }

  bool isRating = false;
  Future<bool> rateMating(RateMatingParameters parameters) async {
    isRating = true;
    emit(RateMating());

    final result = await rateMatingUseCase(parameters);

    final isSuccess = result.fold(
      (failure) {
        isRating = false;
        emit(RateMatingError(extractFirstErrorAuth(failure.error)));
        return false;
      },
      (message) {
        isRating = false;
        emit(RateMatingSuccess());
        return true;
      },
    );
    return isSuccess;
  }

  Future<void> clearMessages(ClearChatParameters parameters) async {
    emit(ClearChatLoading());

    final clearConversationUseCase = sl<ClearConversationUseCase>();
    final result = await clearConversationUseCase(parameters);

    result.fold(
      (failure) {
        emit(ClearChatError(failure.toString()));
      },
      (isSuccess) {
        if (isSuccess) {
          messagesList.clear();
          emit(ClearChatSuccess());
        } else {
          emit(ClearChatError('Failed to clear chat'));
        }
      },
    );
  }

  Future<void> deleteMessage(DeleteMessageParameters parameters) async {
    emit(DeleteMessageLoading());

    final deleteResult = await sl<DeleteMessageUseCase>()(parameters);

    deleteResult.fold(
      (failure) {
        emit(DeleteMessageError(failure.toString()));
      },
      (isSuccess) {
        if (isSuccess) {
          messagesList.removeWhere((msg) => msg.id == parameters.messageId);
          emit(DeleteMessageSuccess());
        } else {
          emit(DeleteMessageError('Failed to delete message'));
        }
      },
    );
  }
}
