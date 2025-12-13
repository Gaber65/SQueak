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
        print(
          '⚠️ [تجاهل تحديث الحالة] محاولة تراجع الحالة للرسالة ${messageId.substring(0, 8)}... : ${oldStatus.name} ($oldWeight) -> ${status.name} ($newWeight)',
        );
        return;
      }
    }

    messageStatuses[messageId] = status;
    _statusStreamController.add(Map.from(messageStatuses));
    print(
      '📊 [تحديث الحالة] الرسالة ${messageId.substring(0, 8)}... : ${oldStatus?.name ?? 'جديدة'} → ${status.name}',
    );
  }

  // Legacy field - keeping for backwards compatibility
  final Map<String, String> deliveryStatuses = {};

  StreamSubscription? _conversationEventSubscription;

  void _subscribeConversationEvents() {
    // Prevent multiple subscriptions
    _conversationEventSubscription?.cancel();
    _conversationEventSubscription = conversationSignalEventStream.stream.listen((
      event,
    ) {
      try {
        if (event.hub != 'ConversationHub') return;

        final method = event.method;
        print('📡 [ConversationEvent] Received: $method → ${event.data}');

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
                final id = serverMsg.id ?? '';

                // Update or insert into messagesList to reflect server-sent message
                final existsById = messagesList.any((m) => m.id == id);
                if (!existsById) {
                  // Try to find a local optimistic message match (by description, fromUserId, createdAt proximity)
                  final matchIndex = messagesList.indexWhere((m) {
                    final sameSender = m.fromUserId == serverMsg.fromUserId;
                    final sameText = m.description == serverMsg.description;
                    final timeDiff =
                        (serverMsg.createdAt.difference(m.createdAt).inSeconds)
                            .abs();
                    return sameSender && sameText && timeDiff <= 10;
                  });

                  if (matchIndex >= 0) {
                    // Replace local optimistic message with server message
                    messagesList[matchIndex] = serverMsg;
                    print(
                      '🔁 [Messages] Replaced local message at index $matchIndex with server message $id',
                    );
                  } else {
                    // Append server message
                    messagesList.add(serverMsg);
                    print(
                      '➕ [Messages] Added server message $id to messagesList',
                    );
                  }
                } else {
                  print('ℹ️ [Messages] Server message $id already present');
                }

                // Set delivery status based on event type
                // تحديد حالة التسليم بناءً على نوع الحدث
                if (method == 'MessageSentAndPetIsNotOnline') {
                  deliveryStatuses[id] = 'one';
                  _updateMessageStatus(id, MessageStatus.sent);
                  print(
                    '✅ [التسليم] الرسالة ${id.substring(0, 8)}... → تم الإرسال (علامة واحدة) - المستلم غير متصل',
                  );
                } else {
                  deliveryStatuses[id] = 'two_grey';
                  _updateMessageStatus(id, MessageStatus.delivered);
                  print(
                    '✅✅ [التسليم] الرسالة ${id.substring(0, 8)}... → تم التسليم (علامتين رماديتين) - لم تُقرأ بعد',
                  );
                }

                emit(ChatMessagesLoaded(List.from(messagesList)));
              } else {
                print('⚠️ [Delivery] Payload is not a Map: $payload');
              }
            } else {
              print('⚠️ [Delivery] Event data missing or empty for $method');
            }
            break;

          case 'MessageRead':
            // Single message was read by recipient
            if (event.data != null && event.data!.isNotEmpty) {
              final data = Map<String, dynamic>.from(event.data![0] as Map);
              final messageId =
                  data['MessageId']?.toString() ??
                  data['messageId']?.toString();

              if (messageId != null) {
                print(
                  '👀 [قراءة الرسالة] الرسالة ${messageId.substring(0, 8)}... تمت قراءتها من المستلم',
                );

                // Update delivery status to 'two_colored' (read)
                // تحديث حالة التسليم إلى "مقروءة" (علامتين ملونتين)
                deliveryStatuses[messageId] = 'two_colored';
                _updateMessageStatus(messageId, MessageStatus.seen);

                // Update message in list
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
            // Messages were delivered when recipient connected to GeneralHub
            // المستقبِل اتصل بـ GeneralHub - الرسائل تم توصيلها
            if (event.data != null && event.data!.isNotEmpty) {
              final data = Map<String, dynamic>.from(event.data![0] as Map);
              final conversationId =
                  data['ConversationId']?.toString() ??
                  data['conversationId']?.toString();

              print(
                '📬 [تم التوصيل] تم توصيل الرسائل - المستقبِل اتصل بالتطبيق - المحادثة: $conversationId',
              );

              // Update all sent messages to delivered status
              // تحديث جميع الرسائل المرسلة إلى حالة "تم التوصيل"
              for (var i = 0; i < messagesList.length; i++) {
                if (!messagesList[i].toMe) {
                  // Only update if current status is 'sent'
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
                      print(
                        '✅ [تم التوصيل] الرسالة ${messagesList[i].id!.substring(0, 8)}... → delivered (✓✓ رمادي)',
                      );
                    }
                  }
                }
              }
              emit(ChatMessagesLoaded(List.from(messagesList)));
            }
            break;

          case 'AllMessagesRead':
            // All messages in conversation were read by recipient
            if (event.data != null && event.data!.isNotEmpty) {
              final data = Map<String, dynamic>.from(event.data![0] as Map);
              final conversationId =
                  data['ConversationId']?.toString() ??
                  data['conversationId']?.toString();

              print(
                '👀👀 [قراءة جميع الرسائل] تمت قراءة جميع الرسائل في المحادثة $conversationId',
              );

              // Mark all outgoing messages as read
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
            // Message status was changed
            if (event.data != null && event.data!.isNotEmpty) {
              final data = Map<String, dynamic>.from(event.data![0] as Map);
              final messageId =
                  data['MessageId']?.toString() ??
                  data['messageId']?.toString();
              final isRead = data['IsRead'] ?? data['isRead'] ?? false;

              if (messageId != null) {
                print(
                  '🔄 [تغيير حالة الرسالة] الرسالة ${messageId.substring(0, 8)}... : isRead=$isRead → ${isRead ? 'مقروءة ✅✅' : 'تم التسليم ✅'}',
                );

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
            // Server signals read - mark all outgoing messages as read for simplicity
            print(
              '📖 [قراءة] استلام حدث $method — تحديث جميع الرسائل الصادرة كمقروءة (علامتين ملونتين)',
            );
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
                  print('✅✅ [Read] Message ${m.id} marked as read');
                }
              }
            }
            emit(ChatMessagesLoaded(List.from(messagesList)));
            break;

          default:
            // Handle other events
            break;
        }
      } catch (e) {
        print(
          '⚠️ [ChatMessagesCubit] Error processing event ${event.method}: $e',
        );
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

  /// Mark all outgoing messages (messages sent by me) as read locally
  /// This sets the `isRead` flag and updates deliveryStatuses to 'two_colored'.
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

  /// Mark all SENT messages as DELIVERED (optimistic update when user comes online)
  void markSentMessagesAsDelivered() {
    print(
      '🚀 [ChatMessagesCubit] Optimistically marking SENT messages as DELIVERED',
    );
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
          // await signalRService.markAllUnreadedMessagesInConversationAsRead(
          //   conversationId: chatId,
          //   petId: petId,
          // );
          print(
            '================================================================================',
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
