// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/chat/data/models/message_model.dart';
import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';
import 'package:squeak/features/mating/chat/domain/usecases/delete_message_use_case.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/message_status.dart';
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

  // Track message status per message id using MessageStatus enum
  final Map<String, MessageStatus> messageStatuses = {};

  // StreamController for real-time status updates (for StreamBuilder in UI)
  final StreamController<Map<String, MessageStatus>> _statusStreamController =
      StreamController<Map<String, MessageStatus>>.broadcast();

  /// Stream of message statuses for UI to listen via StreamBuilder
  Stream<Map<String, MessageStatus>> get messageStatusStream =>
      _statusStreamController.stream;

  /// Get numeric weight for message status to allow comparison
  int _getStatusWeight(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return 1;
      case MessageStatus.delivered:
        return 2;
      case MessageStatus.seen:
        return 3;
    }
  }

  /// Helper to update status and notify stream listeners
  /// تحديث حالة الرسالة وإبلاغ المستمعين
  void _updateMessageStatus(String messageId, MessageStatus status) {
    final oldStatus = messageStatuses[messageId];

    // Prevent regression (e.g. Delivered -> Sent)
    // منع التراجع في الحالة (مثلاً من تم التوصيل -> تم الإرسال)
    if (oldStatus != null) {
      final oldWeight = _getStatusWeight(oldStatus);
      final newWeight = _getStatusWeight(status);

      if (newWeight < oldWeight) {
        return;
      }
    }

    messageStatuses[messageId] = status;
    _statusStreamController.add(Map.from(messageStatuses));
  }

  // Legacy field - keeping for backwards compatibility
  final Map<String, String> deliveryStatuses = {};

  StreamSubscription? _conversationEventSubscription;

  void _subscribeConversationEvents() {
    // Prevent multiple subscriptions
    _conversationEventSubscription?.cancel();
    _conversationEventSubscription = conversationSignalEventStream.stream.listen(
      (
      event,
    ) {
      try {
        try {
          debugPrint('🔁 Conversation event received: ${event.method}');
        } catch (_) {}
        if (event.hub != 'ConversationHub') return;

        final method = event.method;

        switch (method) {
          case 'MessageSentAndPetIsNotOnline':
          case 'MessageSentAndNotReadYet':
            final data = event.data;
            if (data != null && data.isNotEmpty) {
              final payload = data[0];
              if (payload is Map) {
                // Build MessageModel from payload
                final serverMsg = MessageModel.fromJson(
                  Map<String, dynamic>.from(payload),
                );
                try {
                  debugPrint('📨 Server payload for $method: $payload');
                } catch (_) {}
                try {
                  debugPrint(
                      '🔍 ServerMsg id=${serverMsg.id} from=${serverMsg.fromUserId} desc="${serverMsg.description}" createdAt=${serverMsg.createdAt.toIso8601String()}');
                } catch (_) {}
                final id = serverMsg.id ?? '';

                // Update or insert into messagesList to reflect server-sent message
                final existsById = messagesList.any((m) => m.id == id);
                try {
                  debugPrint('existsById=$existsById for server id=$id');
                } catch (_) {}
                if (!existsById) {
                  // Try to find a local optimistic message match (by description, fromUserId, createdAt proximity)
                  final matchIndex = messagesList.indexWhere((m) {
                    final sameSender = m.fromUserId == serverMsg.fromUserId;
                    final sameText = m.description == serverMsg.description;
                    final timeDiff =
                        (serverMsg.createdAt.difference(m.createdAt).inSeconds)
                            .abs();
                    final isLocal = m.id != null && m.id!.startsWith('local_');
                    // Match if it's a local optimistic message, or within 60s window
                    return sameSender && sameText && (isLocal || timeDiff <= 60);
                  });

                  try {
                    debugPrint('matchIndex=$matchIndex for server id=$id');
                  } catch (_) {}

                  if (matchIndex >= 0) {
                    // Replace local optimistic message with server message
                    try {
                      debugPrint('Replacing local optimistic message at $matchIndex with server id=$id');
                    } catch (_) {}
                    messagesList[matchIndex] = serverMsg;
                  } else {
                    // Append server message
                    try {
                      debugPrint('Appending server message id=$id');
                    } catch (_) {}
                    messagesList.add(serverMsg);
                  }
                } else {}

                if (method == 'MessageSentAndPetIsNotOnline') {
                  deliveryStatuses[id] = 'one';
                  _updateMessageStatus(id, MessageStatus.sent);
                } else {
                  deliveryStatuses[id] = 'two_grey';
                  _updateMessageStatus(id, MessageStatus.delivered);
                }

                emit(ChatMessagesLoaded(List.from(messagesList)));
              }
            }
            break;

          case 'MessageRead':
            if (event.data != null && event.data!.isNotEmpty) {
              final data = Map<String, dynamic>.from(event.data![0] as Map);
              final messageId =
                  data['MessageId']?.toString() ??
                  data['messageId']?.toString();

              if (messageId != null) {
                deliveryStatuses[messageId] = 'two_colored';
                _updateMessageStatus(messageId, MessageStatus.seen);
                final index = messagesList.indexWhere((m) => m.id == messageId);
                if (index != -1) {
                  messagesList[index] = messagesList[index].copyWith(
                    status: MessageStatus.seen,
                  );
                  emit(ChatMessagesLoaded(List.from(messagesList)));
                }
              }
            }
            break;

          case 'MessagesDelivered':
            if (event.data != null && event.data!.isNotEmpty) {
              for (var i = 0; i < messagesList.length; i++) {
                if (!messagesList[i].toMe) {
                  if (messagesList[i].status == MessageStatus.sent) {
                    messagesList[i] = messagesList[i].copyWith(
                      status: MessageStatus.delivered,
                    );
                    if (messagesList[i].id != null) {
                      deliveryStatuses[messagesList[i].id!] = 'two_grey';
                      _updateMessageStatus(
                        messagesList[i].id!,
                        MessageStatus.delivered,
                      );
                    }
                  }
                }
              }
              emit(ChatMessagesLoaded(List.from(messagesList)));
            }
            break;

          case 'AllMessagesRead':
            if (event.data != null && event.data!.isNotEmpty) {
              for (var i = 0; i < messagesList.length; i++) {
                if (!messagesList[i].toMe) {
                  messagesList[i] = messagesList[i].copyWith(
                    status: MessageStatus.seen,
                  );
                  if (messagesList[i].id != null) {
                    deliveryStatuses[messagesList[i].id!] = 'two_colored';
                    _updateMessageStatus(
                      messagesList[i].id!,
                      MessageStatus.seen,
                    );
                  }
                }
              }
              emit(ChatMessagesLoaded(List.from(messagesList)));
            }
            break;

          case 'MessageStatusChanged':
            if (event.data != null && event.data!.isNotEmpty) {
              final data = Map<String, dynamic>.from(event.data![0] as Map);
              final messageId =
                  data['MessageId']?.toString() ??
                  data['messageId']?.toString();
              final isRead = data['IsRead'] ?? data['isRead'] ?? false;

              if (messageId != null) {
                deliveryStatuses[messageId] =
                    isRead ? 'two_colored' : 'two_grey';
                _updateMessageStatus(
                  messageId,
                  isRead ? MessageStatus.seen : MessageStatus.delivered,
                );

                final index = messagesList.indexWhere((m) => m.id == messageId);
                if (index != -1) {
                  messagesList[index] = messagesList[index].copyWith(
                    status:
                        isRead ? MessageStatus.seen : MessageStatus.delivered,
                  );
                  emit(ChatMessagesLoaded(List.from(messagesList)));
                }
              }
            }
            break;

          case 'MessageIsRead':
          case 'ReadMessage':
            for (var i = 0; i < messagesList.length; i++) {
              final m = messagesList[i];
              if (!m.toMe) {
                // outgoing message
                if (m.id != null && m.id!.isNotEmpty) {
                  deliveryStatuses[m.id!] = 'two_colored';
                  _updateMessageStatus(m.id!, MessageStatus.seen);
                  messagesList[i] = messagesList[i].copyWith(
                    status: MessageStatus.seen,
                  );
                }
              }
            }
            emit(ChatMessagesLoaded(List.from(messagesList)));
            break;

          default:
            // Handle other events
            break;
        }
      } catch (e) {}
    });
  }

  static get(BuildContext context) =>
      BlocProvider.of<ChatMessagesCubit>(context);

  List<MessageEntity> messagesList = [];
  bool isOtherUserTyping = false;
  int currentPage = 1;
  bool hasMoreMessages = true;
  bool isLoadingMore = false;

  void addReceivedMessage(MessageEntity message, String senderID) {
    // Prevent duplicates: if server-provided id exists and matches, skip.
    final id = message.id;
    if (id != null && id.isNotEmpty) {
      final existsById = messagesList.any((m) => m.id == id);
      if (existsById) {
        return;
      }
    }

    // Try to match and replace local optimistic messages (ids like 'local_*')
    final matchIndex = messagesList.indexWhere((m) {
      final sameSender = m.fromUserId == message.fromUserId;
      final sameText = m.description == message.description;
      final timeDiff = (message.createdAt.difference(m.createdAt).inSeconds).abs();
      final isLocal = m.id != null && m.id!.startsWith('local_');
      return sameSender && sameText && (isLocal || timeDiff <= 60);
    });

    if (matchIndex >= 0) {
      messagesList[matchIndex] = message;
    } else {
      messagesList.add(message);
    }

    emit(ChatMessagesLoaded(List.from(messagesList)));
  }

  void addOutgoingMessage(MessageEntity message) {
    final id = message.id;
    if (id != null && id.isNotEmpty) {
      deliveryStatuses[id] = 'one';
      _updateMessageStatus(id, MessageStatus.sent);
    }

    // Ensure messagesList is a List<MessageEntity> at runtime to avoid
    // runtime type checks when inserting MessageEntity into a list
    messagesList = List<MessageEntity>.from(messagesList);
    messagesList.add(message);
    emit(ChatMessagesLoaded(List.from(messagesList)));
  }

  void markOutgoingMessagesAsRead() {
    for (var i = 0; i < messagesList.length; i++) {
      final m = messagesList[i];
      if (!m.toMe) {
        messagesList[i] = messagesList[i].copyWith(status: MessageStatus.seen);
        if (m.id != null && m.id!.isNotEmpty) {
          deliveryStatuses[m.id!] = 'two_colored';
          _updateMessageStatus(m.id!, MessageStatus.seen);
        }
      }
    }
    emit(ChatMessagesLoaded(List.from(messagesList)));
  }

  void markSentMessagesAsDelivered() {
    bool hasChanges = false;

    for (var i = 0; i < messagesList.length; i++) {
      final m = messagesList[i];
      if (!m.toMe && m.status == MessageStatus.sent) {
        messagesList[i] = messagesList[i].copyWith(
          status: MessageStatus.delivered,
        );
        if (m.id != null && m.id!.isNotEmpty) {
          deliveryStatuses[m.id!] = 'two_grey';
          _updateMessageStatus(m.id!, MessageStatus.delivered);
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      emit(ChatMessagesLoaded(List.from(messagesList)));
    }
  }

  Future<void> loadMessages(String chatId, String petId) async {
    if (chatId.isEmpty) {
      emit(ChatMessagesLoaded([]));
      return;
    }

    await signalRService.connect(conversationId: chatId, petId: petId);
    _subscribeConversationEvents();

    emit(ChatMessagesLoading());
    currentPage = 1;
    hasMoreMessages = true;
    messagesList.clear();
    final result = await getMessagesUseCase(
      GetMessagesParameters(chatId: chatId, pageNumber: currentPage),
    );

    result.fold(
      (failure) {
        emit(ChatMessagesError(failure.toString()));
      },
      (messages) async {
        // Convert server models into a runtime List<MessageEntity> so later
        // adding optimistic MessageEntity items won't fail runtime checks.
        messagesList = List<MessageEntity>.from(messages.reversed.toList());

        hasMoreMessages = messages.length >= 30;

        emit(ChatMessagesLoaded(List.from(messagesList)));
      },
    );
  }

  Future<void> loadMoreMessages(String chatId) async {
    if (!hasMoreMessages || isLoadingMore) {
      return;
    }

    isLoadingMore = true;
    currentPage++;
    final result = await getMessagesUseCase(
      GetMessagesParameters(chatId: chatId, pageNumber: currentPage),
    );

    result.fold(
      (failure) {
        currentPage--;
        isLoadingMore = false;
      },
      (messages) {
        if (messages.isEmpty) {
          hasMoreMessages = false;
        } else {
          final newItems = List<MessageEntity>.from(messages.reversed.toList());
          messagesList.insertAll(0, newItems);
          hasMoreMessages = messages.length >= 30;
        }

        isLoadingMore = false;
        emit(ChatMessagesLoaded(List.from(messagesList)));
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
      await _statusStreamController.close();
      try {
        await signalRService.disconnect();
      } catch (e) {}
      deliveryStatuses.clear();
      messageStatuses.clear();
    } catch (_) {}
    return super.close();
  }
}
