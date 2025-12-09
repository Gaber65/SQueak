// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/chat/data/models/message_model.dart';
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

  // Track delivery status per message id. Values: 'one' (single check),
  // 'two_grey' (two uncolored checks), 'two_colored' (read), or null.
  final Map<String, String> deliveryStatuses = {};

  StreamSubscription? _conversationEventSubscription;

  void _subscribeConversationEvents() {
    // Prevent multiple subscriptions
    _conversationEventSubscription?.cancel();
    _conversationEventSubscription = conversationSignalEventStream.stream
        .listen((event) {
      try {
        if (event.hub != 'ConversationHub') return;

        final method = event.method;
        print('📡 [ConversationEvent] Received: $method → ${event.data}');

        if (method == 'MessageSentAndPetIsNotOnline' ||
            method == 'MessageSentAndNotReadYet') {
          final data = event.data;
          if (data != null && data.isNotEmpty) {
            final payload = data[0];
            if (payload is Map) {
              // Build MessageModel from payload
              final serverMsg = MessageModel.fromJson(Map<String, dynamic>.from(payload));
              final id = serverMsg.id ?? '';

              // Update or insert into messagesList to reflect server-sent message
              final existsById = messagesList.any((m) => m.id == id);
              if (!existsById) {
                // Try to find a local optimistic message match (by description, fromUserId, createdAt proximity)
                final matchIndex = messagesList.indexWhere((m) {
                  final sameSender = m.fromUserId == serverMsg.fromUserId;
                  final sameText = m.description == serverMsg.description;
                  final timeDiff = (serverMsg.createdAt.difference(m.createdAt).inSeconds).abs();
                  return sameSender && sameText && timeDiff <= 10;
                });

                if (matchIndex >= 0) {
                  // Replace local optimistic message with server message
                  messagesList[matchIndex] = serverMsg;
                  print('🔁 [Messages] Replaced local message at index $matchIndex with server message $id');
                } else {
                  // Append server message
                  messagesList.add(serverMsg);
                  print('➕ [Messages] Added server message $id to messagesList');
                }
              } else {
                print('ℹ️ [Messages] Server message $id already present');
              }

              // Set delivery status based on event type
              if (method == 'MessageSentAndPetIsNotOnline') {
                deliveryStatuses[id] = 'one';
                print('✅ [Delivery] Message $id → delivered (one check)');
              } else {
                deliveryStatuses[id] = 'two_grey';
                print('🟦🟦 [Delivery] Message $id → sent but not read (two grey checks)');
              }

              emit(ChatMessagesLoaded(List.from(messagesList)));
            } else {
              print('⚠️ [Delivery] Payload is not a Map: $payload');
            }
          } else {
            print('⚠️ [Delivery] Event data missing or empty for $method');
          }
        } else if (method == 'MessageIsRead' || method == 'ReadMessage') {
          // Server signals read - mark all outgoing messages as read for simplicity
          print('📖 [Read] Received $method — marking outgoing messages as read (two colored checks)');
          for (var i = 0; i < messagesList.length; i++) {
            final m = messagesList[i];
            if (!m.toMe) {
              // outgoing message
              if (m.id != null && m.id!.isNotEmpty) {
                deliveryStatuses[m.id!] = 'two_colored';
                print('✅✅ [Read] Message ${m.id} marked as read');
              }
            }
          }
          emit(ChatMessagesLoaded(List.from(messagesList)));
        } else {
        }
      } catch (e) {
      }
    });
  }


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

    // Subscribe to conversation events so we can update delivery statuses
    _subscribeConversationEvents();

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
          print('================================================================================');
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

  @override
  Future<void> close() async {
    try {
      await _conversationEventSubscription?.cancel();
      try {
        await signalRService.disconnect();
      } catch (e) {
      }
      deliveryStatuses.clear();
    } catch (_) {}
    return super.close();
  }
}
