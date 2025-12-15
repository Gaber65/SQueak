// ignore_for_file: empty_catches

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';
import 'package:squeak/features/mating/chat/data/models/message_model.dart';
import '../../../../../core/service/signalr/signalr_general_service.dart';
import 'chat_app_state.dart';

class ChatAppCubit extends Cubit<ChatAppState> {
  final String petId;
  final String fullName;
  final String image;

  final generalHub = SignalRGeneralHubService();
  final conversationHub = SignalRConversationHubService();

  StreamSubscription? _generalEventSubscription;
  StreamSubscription? _conversationEventSubscription;
  StreamSubscription? _onlineStatusSubscription;
  Timer? _pollingTimer;

  final StreamController<Map<String, bool>> _typingIndicatorsController =
      StreamController<Map<String, bool>>.broadcast();

  Stream<Map<String, bool>> get typingIndicatorsStream =>
      _typingIndicatorsController.stream;

  final StreamController<Map<String, int>> _unreadCountsController =
      StreamController<Map<String, int>>.broadcast();

  Stream<Map<String, int>> get unreadCountsStream =>
      _unreadCountsController.stream;

  Map<String, int> unreadCounts = {};
  Map<String, bool> typingIndicators = {};
  String? currentConversationId;
  String? currentUserId;

  static ChatAppCubit get(context) => BlocProvider.of(context);

  ChatAppCubit({
    required this.petId,
    required this.fullName,
    required this.image,
  }) : super(ChatAppInitial());

  Future<void> initialize() async {
    emit(ChatAppLoading());

    try {
      await generalHub.connect(petId: petId, fullName: fullName, image: image);
      _listenToOnlineStatusUpdates();
      _setupGeneralHubListeners();
      _listenToGeneralEvents();
      await _loadInitialData();
      emit(ChatAppConnected());
    } catch (e) {
      emit(ChatAppError('Failed to initialize: $e'));
    }
  }

  void _setupGeneralHubListeners() {
    generalHub.onConnectionRegistered((data) {
      emit(ConnectionRegistered(data));
    });

    generalHub.onFriendConnectionChanged((data) {
      final friendPetId = data['PetId'] as String?;
      final isOnline = data['IsOnline'] as bool? ?? false;

      if (friendPetId != null) {
        emit(FriendOnlineStatusChanged(friendPetId, isOnline));
      }
    });

    generalHub.onUnreadedMessagesCount((data) {
      final conversationId = data['ConversationId'] as String?;
      final count = data['Count'] as int? ?? 0;

      if (conversationId != null) {
        unreadCounts[conversationId] = count;
        emit(UnreadCountUpdated(conversationId, count));
      } else {}
    });

    generalHub.onIncreaseUnReadCount((data) {
      (data['ToPetId'] ?? data['toPetId'])?.toString();
      final fromPetId = (data['FromPetId'] ?? data['fromPetId'])?.toString();
      final conversationId =
          (data['ConversationId'] ?? data['conversationId'])?.toString();
      final unreadCount =
          (data['UnReadCount'] ?? data['unReadCount']) as int? ?? 0;
      final contentMessage =
          (data['contentMessage'] ??
                  data['contentMessage'] ??
                  data['ContentMessage'] ??
                  data['contentMessage'])
              ?.toString() ??
          '';
      final imageMessage =
          (data['ImageMessage'] ?? data['imageMessage']) as bool? ?? false;
      final videoMessage =
          (data['VideoMessage'] ?? data['videoMessage']) as bool? ?? false;
      final fileMessage =
          (data['FileMessage'] ?? data['fileMessage']) as bool? ?? false;
      final audioMessage =
          (data['AudioMessage'] ?? data['audioMessage']) as bool? ?? false;
      if (conversationId != null && conversationId.isNotEmpty) {
        unreadCounts[conversationId] = unreadCount;
        _unreadCountsController.add(Map.from(unreadCounts));
        emit(UnreadCountUpdated(conversationId, unreadCount));
        emit(
          NewMessageDetected(
            conversationId: conversationId,
            fromPetId: fromPetId ?? '',
            contentMessage: contentMessage,
            imageMessage: imageMessage,
            videoMessage: videoMessage,
            fileMessage: fileMessage,
            audioMessage: audioMessage,
          ),
        );
      }
    });

    generalHub.onFriendIsTyping((data) {
      final friendPetId = (data['PetId'] ?? data['petId']) as String?;
      final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool? ?? false;
      final fromPetId = (data['FromPetId'] ?? data['fromPetId']) as String?;

      if (friendPetId != null && friendPetId.isNotEmpty) {
        typingIndicators[friendPetId] = isTyping;
        _typingIndicatorsController.add(Map.from(typingIndicators));

        emit(FriendTypingInGeneral(friendPetId, isTyping, fromPetId ?? ''));
      }
    });

    generalHub.onMessagesDelivered((data) {
      final conversationId = data['ConversationId']?.toString();
      data['DeliveredToPetId']?.toString();
      if (conversationId != null) {
        conversationSignalEventStream.add(
          ConversationSignalEvent('ConversationHub', 'MessagesDelivered', [
            data,
          ]),
        );
      }
    });
  }

  void _listenToGeneralEvents() {
    _generalEventSubscription?.cancel();

    _generalEventSubscription = signalEventStream.stream.listen((event) {
      if (event.method == 'UnreadedMessagesCountPetConversation') {
        try {
          if (event.data != null && event.data!.isNotEmpty) {
            final data = Map<String, dynamic>.from(event.data![0] as Map);
            final conversationId =
                (data['ConversationId'] ?? data['conversationId']) as String?;
            final count = (data['Count'] ?? data['count']) as int? ?? 0;

            if (conversationId != null) {
              unreadCounts[conversationId] = count;
              emit(UnreadCountUpdated(conversationId, count));
            }
          }
        } catch (e) {}
      }
    });
  }

  final Map<String, bool> _lastOnlineStatus = {};
  void _listenToOnlineStatusUpdates() {
    _onlineStatusSubscription?.cancel();

    _onlineStatusSubscription = generalHub.onlineStatusStream.listen((
      statusMap,
    ) {
      for (final entry in statusMap.entries) {
        final friendId = entry.key;
        final isOnline = entry.value;
        final wasOnline = _lastOnlineStatus[friendId] ?? false;
        _lastOnlineStatus[friendId] = isOnline;
        if (isOnline && !wasOnline) {
          if (conversationHub.isConnected) {
            markMessagesAsDelivered(friendId);
          }
          emit(FriendOnlineStatusChanged(friendId, true));
        }
      }
      emit(ChatAppConnected());
    });
  }

  Future<void> _loadInitialData() async {
    try {
      final counts = await generalHub.getUnreadMessageCounts(petId);
      if (counts != null) {
        unreadCounts = counts;
        emit(UnreadCountsPolled(counts));
      }
    } catch (e) {}
  }

  Future<void> joinConversation(String conversationId) async {
    try {
      emit(JoiningConversation(conversationId));
      currentConversationId = conversationId;
      await conversationHub.connect(
        conversationId: conversationId,
        petId: petId,
      );
      _setupConversationListeners();
      _listenToConversationEvents();
      final unreadIds = await conversationHub.getUnreadMessageIds(
        conversationId: conversationId,
        petId: petId,
      );

      emit(ConversationJoined(conversationId, unreadIds ?? []));
    } catch (e) {
      emit(ChatAppError('Failed to join conversation: $e'));
    }
  }

  void _setupConversationListeners() {
    conversationHub.onPetJoinedToConversation((data) {
      final joinedUserId = data['userId'] as String?;
      if (joinedUserId != null) {
        currentUserId = joinedUserId;
      }
      emit(PetJoinedConversation(data));
    });

    conversationHub.onPetLeftConversation((data) {
      emit(PetLeftConversation(data));
    });

    generalHub.onFriendIsTyping((data) {
      final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool? ?? false;
      final friendPetId = (data['PetId'] ?? data['petId']) as String?;

      if (friendPetId != null &&
          friendPetId.isNotEmpty &&
          currentConversationId != null) {
        emit(
          FriendTypingInConversation(
            currentConversationId!,
            friendPetId,
            isTyping,
          ),
        );
      } else {}
    });
    conversationHub.onMessageReceived((data) {
      var message = MessageModel.fromJson(data);
      if (message.toMe) {
        emit(MessageReceived(currentConversationId!, message));
      }
    });

    conversationHub.onMessageIsRead((isRead) {
      if (isRead && currentConversationId != null) {
        emit(MessagesMarkedAsRead(currentConversationId!));
      }
    });

    conversationHub.onSingleMessageRead((data) {
      final messageId =
          data['MessageId']?.toString() ?? data['messageId']?.toString();
      if (messageId != null && currentConversationId != null) {
        emit(SingleMessageRead(currentConversationId!, messageId));
      }
    });

    conversationHub.onAllMessagesReadInConversation((data) {
      final conversationId =
          data['ConversationId']?.toString() ??
          data['conversationId']?.toString();
      if (conversationId != null) {
        unreadCounts[conversationId] = 0;
        emit(AllMessagesRead(conversationId));
      }
    });

    conversationHub.onMessageSentAndPetIsNotOnline((data) {
      final message = MessageModel.fromJson(data);
      emit(MessageSentUnread(currentConversationId!, message));
    });

    conversationHub.onMessageSentAndNotReadYet((data) {
      final message = MessageModel.fromJson(data);

      markMessagesAsDelivered(message.toUserId);

      emit(MessageSentUnread(currentConversationId!, message));
    });

    conversationHub.onUnreadedMessagesCountPetConversation((data) {
      final conversationId =
          (data['ConversationId'] ?? data['conversationId']) as String?;
      final count = (data['Count'] ?? data['count']) as int? ?? 0;

      if (conversationId != null) {
        unreadCounts[conversationId] = count;

        emit(UnreadCountUpdated(conversationId, count));
      }
    });
  }

  void _listenToConversationEvents() {
    _conversationEventSubscription = conversationSignalEventStream.stream
        .listen((event) {});
  }

  Future<void> sendMessage({
    required String conversationId,
    required String toPetId,
    required String description,
    String? image,
    String? video,
    String? audio,
    String? file,
  }) async {
    try {
      final command = {
        'ConversationId': conversationId,
        'ToPetId': toPetId,
        'Description': description,
        if (image != null) 'Image': image,
        if (video != null) 'Video': video,
        if (audio != null) 'Audio': audio,
        if (file != null) 'file': file,
      };

      await conversationHub.sendMessageToUser(command);
    } catch (e) {
      emit(ChatAppError('Failed to send message: $e'));
    }
  }

  Future<void> increaseUnreadMessageCount({
    required String toPetId,
    required String fromPetId,
    required String conversationId,
    required String content,
    bool imageMessage = false,
    bool videoMessage = false,
    bool fileMessage = false,
    bool audioMessage = false,
  }) async {
    try {
      await generalHub.increaseUnReadCountMessageForConversation(
        toPetId: toPetId,
        fromPetId: fromPetId,
        conversationId: conversationId,
        content: content,
        imageMessage: imageMessage,
        videoMessage: videoMessage,
        fileMessage: fileMessage,
        audioMessage: audioMessage,
      );
    } catch (e) {}
  }

  Future<void> setTyping({
    required String conversationId,
    required bool isTyping,
  }) async {
    try {
      await conversationHub.setTyping(
        conversationId: conversationId,
        petId: petId,
        isTyping: isTyping,
      );
    } catch (e) {}
  }

  Future<void> setTypingInGeneral({
    required String petId,
    required bool isTyping,
    required String fromPetId,
  }) async {
    try {
      await generalHub.setTypingIndicator(
        toPetId: petId,
        isTyping: isTyping,
        fromPetId: this.petId,
      );
    } catch (e) {}
  }

  Future<void> markMessagesAsDelivered(String toPetId) async {
    try {
      final isOnline = generalHub.isPetOnlineFromDict(toPetId);
      if (isOnline) {
        await conversationHub.markMessagesAsDelivered(petId: toPetId);
      }
    } catch (e) {}
  }

  Future<void> leaveConversation() async {
    try {
      await conversationHub.disconnect();
      await _loadInitialData();

      currentConversationId = null;
      currentUserId = null;

      emit(ConversationLeft());

      emit(ChatAppConnected());
    } catch (e) {
      emit(ChatAppError('Failed to leave conversation: $e'));
    }
  }

  /// فحص حالة الاتصال للصديق من القاموس المحلي (بدون استدعاء الخادم)
  /// Check if pet is online from local dictionary (without server call)
  Future<bool> checkIfPetOnline(String friendPetId) async {
    try {
      final isOnline = generalHub.isPetOnlineFromDict(friendPetId);
      return isOnline;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    await _generalEventSubscription?.cancel();
    await _conversationEventSubscription?.cancel();
    await _onlineStatusSubscription?.cancel(); 
    await _typingIndicatorsController.close();
    await _unreadCountsController.close();
    await generalHub.disconnect();
    await conversationHub.disconnect();
    return super.close();
  }
}
