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
    print('🚀 [ChatAppCubit] Initializing for petId: $petId');
    emit(ChatAppLoading());

    try {
      print('🔌 [ChatAppCubit] Connecting to GeneralHub...');
      // Connect to GeneralHub
      await generalHub.connect(petId: petId, fullName: fullName, image: image);
      print('✅ [ChatAppCubit] GeneralHub connected successfully');

      // Setup event listeners
      print('🎧 [ChatAppCubit] Setting up GeneralHub listeners...');
      _setupGeneralHubListeners();
      _listenToGeneralEvents();
      print('✅ [ChatAppCubit] GeneralHub listeners configured');

      // Get initial data
      print('📥 [ChatAppCubit] Loading initial data (online friends & unread counts)...');
      await _loadInitialData();
      print('✅ [ChatAppCubit] Initial data loaded');

      emit(ChatAppConnected());
      print('🎉 [ChatAppCubit] Initialization complete - GeneralHub is active');
    } catch (e) {
      print('❌ [ChatAppCubit] Failed to initialize: $e');
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
      print('📥 Raw unread count data: $data');
      final conversationId = data['ConversationId'] as String?;
      final count = data['Count'] as int? ?? 0;

      if (conversationId != null) {
        unreadCounts[conversationId] = count;
        print(
          '📬 Unread count for conversation $conversationId changed to: $count',
        );
        print('📊 Current unread counts map: $unreadCounts');
        emit(UnreadCountUpdated(conversationId, count));
      } else {
        print('⚠️ Unread count event missing ConversationId!');
      }
    });

    // Friend typing in general
    generalHub.onFriendIsTyping((data) {
      print('📥 [GeneralHub] Raw typing data: $data');
      final friendPetId = (data['PetId'] ?? data['petId']) as String?;
      final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool? ?? false;

      if (friendPetId != null && friendPetId.isNotEmpty) {
        typingIndicators[friendPetId] = isTyping;
        print(
          '⌨️ [GeneralHub] Friend $friendPetId typing status changed to: $isTyping',
        );
        print('📊 [GeneralHub] Current typing indicators: $typingIndicators');
        emit(FriendTypingInGeneral(friendPetId, isTyping));
      } else {
        print('⚠️ [GeneralHub] Typing event has empty petId!');
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
        print('✅ Loaded ${counts.length} unread counts: $unreadCounts');
        print(
          '📋 Conversation IDs with unread messages: ${counts.keys.toList()}',
        );
      } else {
        print('⚠️ No unread counts returned from server');
      }
    } catch (e) {
      print('❌ Error loading initial data: $e');
    }
  }

  Future<void> joinConversation(String conversationId) async {
    try {
      print('────────────────────────────────────────');
      print('🔵 [ChatAppCubit] Starting to join conversation: $conversationId');
      print('📡 [ChatAppCubit] GeneralHub status: ${generalHub.isConnected ? "CONNECTED" : "DISCONNECTED"}');
      print('📡 [ChatAppCubit] ConversationHub status: ${conversationHub.isConnected ? "CONNECTED" : "DISCONNECTED"}');
      emit(JoiningConversation(conversationId));

      currentConversationId = conversationId;
      print('🔌 [ChatAppCubit] Connecting to ConversationHub for conversation: $conversationId');
      print('ℹ️  [ChatAppCubit] GeneralHub will remain connected');
      await conversationHub.connect(
        conversationId: conversationId,
        petId: petId,
      );
      print('✅ [ChatAppCubit] ConversationHub connected successfully');
      print('📊 [ChatAppCubit] Active connections: GeneralHub=✓, ConversationHub=✓');

      print('🎧 [ChatAppCubit] Setting up ConversationHub listeners...');
      _setupConversationListeners();
      _listenToConversationEvents();
      print('✅ [ChatAppCubit] ConversationHub listeners configured');

      // Get unread messages
      print('📥 [ChatAppCubit] Fetching unread message IDs...');
      final unreadIds = await conversationHub.getUnreadMessageIds(
        conversationId: conversationId,
        petId: petId,
      );
      print('📬 [ChatAppCubit] Found ${unreadIds?.length ?? 0} unread messages');

      // Mark all messages as read when opening the conversation
      print('📖 [ChatAppCubit] Marking all unread messages as read...');
      await conversationHub.markAllUnreadedMessagesInConversationAsRead(
        conversationId: conversationId,
        petId: petId,
      );
      print('✅ [ChatAppCubit] All messages marked as read');

      emit(ConversationJoined(conversationId, unreadIds ?? []));
      print('🎉 [ChatAppCubit] Successfully joined conversation: $conversationId');
      print('────────────────────────────────────────');
    } catch (e) {
      print('❌ [ChatAppCubit] Error joining conversation: $e');
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
      print('📥 [ConversationHub] Raw typing data: $data');
      final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool? ?? false;
      final friendPetId = (data['PetId'] ?? data['petId']) as String?;

      if (friendPetId != null &&
          friendPetId.isNotEmpty &&
          currentConversationId != null) {
        print(
          '⌨️ [ConversationHub] Friend $friendPetId typing in conversation $currentConversationId: $isTyping',
        );
        emit(
          FriendTypingInConversation(
            currentConversationId!,
            friendPetId,
            isTyping,
          ),
        );
      } else {
        print(
          '⚠️ [ConversationHub] Typing event missing data: friendPetId=$friendPetId, conversationId=$currentConversationId',
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
      // Send typing to ConversationHub (for users in the chat)
      await conversationHub.setTyping(
        conversationId: conversationId,
        petId: petId,
        isTyping: isTyping,
      );

      // ALSO send typing to GeneralHub (for chat list)
      // Extract the friend's petId from the conversationId or get it from the chat
      // For now, we'll send it to GeneralHub as well
      print('⌨️ Setting typing indicator: isTyping=$isTyping');
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
      print('────────────────────────────────────────');
      print('👋 [ChatAppCubit] Leaving conversation: $currentConversationId');
      print('📡 [ChatAppCubit] Current GeneralHub status: ${generalHub.isConnected ? "CONNECTED" : "DISCONNECTED"}');
      print('📡 [ChatAppCubit] Current ConversationHub status: ${conversationHub.isConnected ? "CONNECTED" : "DISCONNECTED"}');
      
      print('🔌 [ChatAppCubit] Disconnecting from ConversationHub...');
      await conversationHub.disconnect();
      print('✅ [ChatAppCubit] ConversationHub disconnected');
      
      // Ensure GeneralHub is still connected
      if (!generalHub.isConnected) {
        print('⚠️ [ChatAppCubit] GeneralHub is disconnected! Reconnecting...');
        await generalHub.connect(petId: petId, fullName: fullName, image: image);
        print('✅ [ChatAppCubit] GeneralHub reconnected');
      } else {
        print('ℹ️  [ChatAppCubit] GeneralHub remains connected');
      }
      
      // Refresh data from GeneralHub
      print('🔄 [ChatAppCubit] Refreshing online friends and unread counts...');
      await _loadInitialData();
      print('✅ [ChatAppCubit] Data refreshed successfully');
      
      print('📊 [ChatAppCubit] Active connections: GeneralHub=✓, ConversationHub=✗');
      
      currentConversationId = null;
      currentUserId = null;
      emit(ConversationLeft());
      print('🎉 [ChatAppCubit] Successfully left conversation');
      print('────────────────────────────────────────');
    } catch (e) {
      print('❌ [ChatAppCubit] Error leaving conversation: $e');
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
    print('────────────────────────────────────────');
    print('🛑 [ChatAppCubit] Closing ChatAppCubit - disconnecting all hubs');
    print('📡 [ChatAppCubit] GeneralHub status: ${generalHub.isConnected ? "CONNECTED" : "DISCONNECTED"}');
    print('📡 [ChatAppCubit] ConversationHub status: ${conversationHub.isConnected ? "CONNECTED" : "DISCONNECTED"}');
    
    print('🔇 [ChatAppCubit] Cancelling event subscriptions...');
    await _generalEventSubscription?.cancel();
    await _conversationEventSubscription?.cancel();
    print('✅ [ChatAppCubit] Event subscriptions cancelled');
    
    print('🔌 [ChatAppCubit] Disconnecting from GeneralHub...');
    await generalHub.disconnect();
    print('✅ [ChatAppCubit] GeneralHub disconnected');
    
    print('🔌 [ChatAppCubit] Disconnecting from ConversationHub...');
    await conversationHub.disconnect();
    print('✅ [ChatAppCubit] ConversationHub disconnected');
    
    print('🎉 [ChatAppCubit] ChatAppCubit closed successfully');
    print('────────────────────────────────────────');
    return super.close();
  }
}
