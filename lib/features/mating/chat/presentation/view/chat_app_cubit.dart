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

  Map<String, bool> onlineFriends = {};
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
      // Connect to GeneralHub
      await generalHub.connect(petId: petId, fullName: fullName, image: image);

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
        print('🔄 Friend $friendPetId online status changed to: $isOnline');
        print('📊 Current online friends: $onlineFriends');
        emit(FriendOnlineStatusChanged(friendPetId, isOnline));
      }
    });

    // Unread messages count
    generalHub.onUnreadedMessagesCount((data) {
      final conversationId = data['ConversationId'] as String?;
      final count = data['Count'] as int? ?? 0;

      if (conversationId != null) {
        unreadCounts[conversationId] = count;
        print('📬 Unread count for $conversationId changed to: $count');
        print('📊 Current unread counts: $unreadCounts');
        emit(UnreadCountUpdated(conversationId, count));
      }
    });

    // Friend typing in general
    generalHub.onFriendIsTyping((data) {
      print('📥 Raw typing data: $data');
      final friendPetId = (data['PetId'] ?? data['petId']) as String?;
      final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool? ?? false;

      if (friendPetId != null && friendPetId.isNotEmpty) {
        typingIndicators[friendPetId] = isTyping;
        print('⌨️ Friend $friendPetId typing status changed to: $isTyping');
        print('📊 Current typing indicators: $typingIndicators');
        emit(FriendTypingInGeneral(friendPetId, isTyping));
      } else {
        print('⚠️ Typing event has empty petId!');
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
        print('📥 Raw friends data: $friends');
        for (var friend in friends) {
          print('👤 Processing friend: ${friend.toString()}');
          print('   - petId: "${friend.petId}"');
          print('   - isOnline: ${friend.isOnline}');

          if (friend.petId.isNotEmpty) {
            onlineFriends[friend.petId] = friend.isOnline;
          } else {
            print('⚠️ Friend has empty petId!');
          }
        }
        print('✅ Loaded ${friends.length} online friends');
        print('📊 Initial online friends: $onlineFriends');
      }

      // Get unread message counts
      final counts = await generalHub.getUnreadMessageCounts(petId);
      if (counts != null) {
        unreadCounts = counts;
        print('✅ Loaded unread counts: $unreadCounts');
      }
    } catch (e) {
      print('Error loading initial data: $e');
    }
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
      // Store current user's ID when joining
      final joinedUserId = data['userId'] as String?;
      if (joinedUserId != null) {
        currentUserId = joinedUserId;
        print('💾 Stored current userId: $currentUserId');
      }
      emit(PetJoinedConversation(data));
    });

    // Pet left
    conversationHub.onPetLeftConversation((data) {
      print('👋 Pet left conversation: $data');
      emit(PetLeftConversation(data));
    });

    // Friend typing in conversation
    conversationHub.onFriendIsTyping((data) {
      print('📥 Raw typing data (conversation): $data');
      final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool? ?? false;
      final friendPetId = (data['PetId'] ?? data['petId']) as String?;

      if (friendPetId != null &&
          friendPetId.isNotEmpty &&
          currentConversationId != null) {
        print(
          '⌨️ Friend $friendPetId typing in conversation $currentConversationId: $isTyping',
        );
        emit(
          FriendTypingInConversation(
            currentConversationId!,
            friendPetId,
            isTyping,
          ),
        );
      }
    });

    // Receive message
    conversationHub.onMessageReceived((data) {
      var message = MessageModel.fromJson(data);
      emit(MessageReceived(currentConversationId!, message));
    });

    // Message is read
    conversationHub.onMessageIsRead((isRead) {
      if (isRead && currentConversationId != null) {
        emit(MessagesMarkedAsRead(currentConversationId!));
      }
    });

    // Message sent but not online
    conversationHub.onMessageSentAndPetIsNotOnline((data) {
      final message = MessageModel.fromJson(data);

      emit(MessageSentUnread(currentConversationId!, message));
    });

    // Message sent but not read yet
    conversationHub.onMessageSentAndNotReadYet((data) {
      final message = MessageModel.fromJson(data);
      emit(MessageSentUnread(currentConversationId!, message));
    });
  }

  void _listenToConversationEvents() {
    _conversationEventSubscription = conversationSignalEventStream.stream
        .listen((event) {
          print('📡 Conversation Event: ${event.method}');
        });
  }


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
      currentUserId = null;
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
