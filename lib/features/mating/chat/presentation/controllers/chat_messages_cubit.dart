import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';
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
  final signalRService = SignalRConversationHubService();

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
  bool isOtherUserTyping = false;

  void addReceivedMessage(MessageEntity message, String senderID) {
    messagesList.add(message);
    emit(ChatMessagesLoaded(List.from(messagesList)));
  }

  Future<void> loadMessages(String chatId, String petId) async {
    if (chatId.isEmpty) {
      emit(ChatMessagesLoaded([]));
      return;
    }

    print('🔌 Connecting to SignalR conversation hub...');
    await signalRService.connect(conversationId: chatId, petId: petId);
    print('✅ Connected to conversation hub');

    emit(ChatMessagesLoading());

    print('📥 Loading messages for chat: $chatId');
    final result = await getMessagesUseCase(
      GetMessagesParameters(chatId: chatId),
    );

    result.fold(
      (failure) {
        print('❌ Failed to load messages: $failure');
        emit(ChatMessagesError(failure.toString()));
      },
      (messages) async {
        messagesList = messages.reversed.toList();
        print('✅ Loaded ${messagesList.length} messages');

        // Mark all messages as read when opening the chat
        print('📖 Marking all unread messages as read...');
        try {
          await signalRService.markAllUnreadedMessagesInConversationAsRead(
            conversationId: chatId,
            petId: petId,
          );
          print('✅ All messages marked as read');
        } catch (e) {
          print('❌ Error marking messages as read: $e');
        }

        emit(ChatMessagesLoaded(messages));
      },
    );
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
