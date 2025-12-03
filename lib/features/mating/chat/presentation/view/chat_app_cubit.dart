import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';
import 'package:squeak/features/mating/chat/data/models/message_model.dart';
import 'package:squeak/features/mating/chat/domain/entities/message_entity.dart';
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

  Map<String, bool> onlineFriends = {};
  Map<String, int> unreadCounts = {};
  Map<String, bool> typingIndicators = {};
  String? currentConversationId;

  static ChatAppCubit get(context) => BlocProvider.of(context);

  ChatAppCubit({
    required this.petId,
    required this.fullName,
    required this.image,
  }) : super(ChatAppInitial());

  Future<void> initialize() async {
    emit(ChatAppLoading());

    try {
      // Connect to GeneralHub
      await generalHub.connect(
        petId: petId,
        fullName: fullName,
        image: image,
      );

      // Setup event listeners
      _setupGeneralHubListeners();
      _listenToGeneralEvents();

      // Get initial data
      await _loadInitialData();

      emit(ChatAppConnected());
    } catch (e) {
      emit(ChatAppError('Failed to initialize: $e'));
    }
  }

  void _setupGeneralHubListeners() {
    // Connection registered
    generalHub.onConnectionRegistered((data) {
      print('✅ Connection Registered: $data');
      emit(ConnectionRegistered(data));
    });

    // Friend connection changed
    generalHub.onFriendConnectionChanged((data) {
      final friendPetId = data['PetId'] as String?;
      final isOnline = data['IsOnline'] as bool? ?? false;

      if (friendPetId != null) {
        onlineFriends[friendPetId] = isOnline;
        emit(FriendOnlineStatusChanged(friendPetId, isOnline));
      }
    });

    // Unread messages count
    generalHub.onUnreadedMessagesCount((data) {
      final conversationId = data['ConversationId'] as String?;
      final count = data['Count'] as int? ?? 0;

      if (conversationId != null) {
        unreadCounts[conversationId] = count;
        emit(UnreadCountUpdated(conversationId, count));
      }
    });

    // Friend typing in general
    generalHub.onFriendIsTyping((data) {
      final friendPetId = data['PetId'] as String?;
      final isTyping = data['IsTyping'] as bool? ?? false;

      if (friendPetId != null) {
        typingIndicators[friendPetId] = isTyping;
        emit(FriendTypingInGeneral(friendPetId, isTyping));
      }
    });
  }

  void _listenToGeneralEvents() {
    _generalEventSubscription = signalEventStream.stream.listen((event) {
      print('📡 General Event: ${event.method}');
    });
  }

  Future<void> _loadInitialData() async {
    try {
      // Get online friends
      final friends = await generalHub.getAllMyOnlinePetFriends(petId);
      if (friends != null) {
        for (var friend in friends) {
          onlineFriends[friend.petId] = friend.isOnline;
        }
      }

      // Get unread message counts
      final counts = await generalHub.getUnreadMessageCounts(petId);
      if (counts != null) {
        unreadCounts = counts;
      }
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  // ==================== CONVERSATION METHODS ====================

  Future<void> joinConversation(String conversationId) async {
    try {
      emit(JoiningConversation(conversationId));

      currentConversationId = conversationId;

      // Connect to conversation hub
      await conversationHub.connect(
        conversationId: conversationId,
        petId: petId,
      );

      // Setup conversation listeners
      _setupConversationListeners();
      _listenToConversationEvents();

      // Get unread messages
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
    // Pet joined
    conversationHub.onPetJoinedToConversation((data) {
      print('✅ Pet joined conversation: $data');
      emit(PetJoinedConversation(data));
    });

    // Pet left
    conversationHub.onPetLeftConversation((data) {
      print('👋 Pet left conversation: $data');
      emit(PetLeftConversation(data));
    });

    // Friend typing in conversation
    conversationHub.onFriendIsTyping((data) {
      final isTyping = data['IsTyping'] as bool? ?? false;
      final friendPetId = data['PetId'] as String?;

      if (friendPetId != null && currentConversationId != null) {
        emit(FriendTypingInConversation(currentConversationId!, friendPetId, isTyping));
      }
    });

    // Receive message
    conversationHub.onMessageReceived((data) {
      var mod = MessageModel.fromJson(data);
      emit(MessageReceived(currentConversationId!, mod));
    });

    // Message is read
    conversationHub.onMessageIsRead((isRead) {
      if (isRead && currentConversationId != null) {
        emit(MessagesMarkedAsRead(currentConversationId!));
      }
    });

    // Message sent but not online
    conversationHub.onMessageSentAndPetIsNotOnline((data) {
      final message = _parseMessage(data);
      if (message != null && currentConversationId != null) {
        emit(MessageSentOffline(currentConversationId!, message));
      }
    });

    // Message sent but not read yet
    conversationHub.onMessageSentAndNotReadYet((data) {
      final message = _parseMessage(data);
      if (message != null && currentConversationId != null) {
        emit(MessageSentUnread(currentConversationId!, message));
      }
    });
  }

  void _listenToConversationEvents() {
    _conversationEventSubscription = conversationSignalEventStream.stream.listen((event) {
      print('📡 Conversation Event: ${event.method}');
    });
  }

  MessageEntity? _parseMessage(Map<String, dynamic> data) {
    try {
      return MessageEntity(
        id: data['Id'] as String?,
        description: data['Description'] as String? ?? '',
        image: data['Image'] as String?,
        video: data['Video'] as String?,
        audio: data['Audio'] as String?,
        isRead: data['IsRead'] as bool? ?? false,
        fromUserId: data['FromUserId'] as String? ?? '',
        toUserId: data['ToUserId'] as String? ?? '',
        createdAt: data['CreatedAt'] != null
            ? DateTime.parse(data['CreatedAt'])
            : DateTime.now(),
        toMe: data['ToMe'] as bool? ?? false,
      );
    } catch (e) {
      print('Error parsing message: $e');
      return null;
    }
  }

  // ==================== ACTIONS ====================

  Future<void> sendMessage({
    required String conversationId,
    required String toPetId,
    required String description,
    String? image,
    String? video,
    String? audio,
  }) async {
    try {
      final command = {
        'ConversationId': conversationId,
        'ToPetId': toPetId,
        'Description': description,
        if (image != null) 'Image': image,
        if (video != null) 'Video': video,
        if (audio != null) 'Audio': audio,
      };

      await conversationHub.sendMessageToUser(command);
    } catch (e) {
      emit(ChatAppError('Failed to send message: $e'));
    }
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
    } catch (e) {
      print('Error setting typing: $e');
    }
  }

  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      await conversationHub.markAllUnreadedMessagesInConversationAsRead(
        conversationId: conversationId,
        petId: petId,
      );
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> leaveConversation() async {
    try {
      await conversationHub.disconnect();
      currentConversationId = null;
      emit(ConversationLeft());
    } catch (e) {
      print('Error leaving conversation: $e');
    }
  }

  Future<bool> checkIfPetOnline(String friendPetId) async {
    try {
      return await generalHub.isPetOnline(friendPetId) ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _generalEventSubscription?.cancel();
    await _conversationEventSubscription?.cancel();
    await generalHub.disconnect();
    await conversationHub.disconnect();
    return super.close();
  }
}
