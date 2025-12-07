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
  Timer? _pollingTimer;

  Map<String, bool> onlineFriends = {};
  Map<String, int> unreadCounts = {};
  Map<String, bool> typingIndicators = {};
  String? currentConversationId;
  String? currentUserId;
  int _totalUnreadMessages = 0;

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
      print(
        '📥 [ChatAppCubit] Loading initial data (online friends & unread counts)...',
      );
      await _loadInitialData();
      print('✅ [ChatAppCubit] Initial data loaded');

      // Start periodic polling for unread messages
      _startPeriodicPolling();
      print('⏰ [ChatAppCubit] Started periodic polling every 2 seconds');

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
    // Cancel existing subscription to avoid duplicates
    _generalEventSubscription?.cancel();

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
        _totalUnreadMessages = counts.values.fold(
          0,
          (sum, count) => sum + count,
        );
        print('✅ Loaded ${counts.length} unread counts: $unreadCounts');
        print('📊 Initial total unread messages: $_totalUnreadMessages');
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
      print(
        '📡 [ChatAppCubit] GeneralHub status: ${generalHub.isConnected ? "CONNECTED" : "DISCONNECTED"}',
      );
      print(
        '📡 [ChatAppCubit] ConversationHub status: ${conversationHub.isConnected ? "CONNECTED" : "DISCONNECTED"}',
      );
      emit(JoiningConversation(conversationId));

      currentConversationId = conversationId;
      print(
        '🔌 [ChatAppCubit] Connecting to ConversationHub for conversation: $conversationId',
      );
      print('ℹ️  [ChatAppCubit] GeneralHub will remain connected');
      await conversationHub.connect(
        conversationId: conversationId,
        petId: petId,
      );
      print('✅ [ChatAppCubit] ConversationHub connected successfully');
      print(
        '📊 [ChatAppCubit] Active connections: GeneralHub=✓, ConversationHub=✓',
      );

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
      print(
        '📬 [ChatAppCubit] Found ${unreadIds?.length ?? 0} unread messages',
      );

      // Mark all messages as read when opening the conversation
      print('📖 [ChatAppCubit] Marking all unread messages as read...');
      await conversationHub.markAllUnreadedMessagesInConversationAsRead(
        conversationId: conversationId,
        petId: petId,
      );
      print('✅ [ChatAppCubit] All messages marked as read');

      emit(ConversationJoined(conversationId, unreadIds ?? []));
      print(
        '🎉 [ChatAppCubit] Successfully joined conversation: $conversationId',
      );
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
      print(
        '📡 [ChatAppCubit] Current GeneralHub status: ${generalHub.isConnected ? "CONNECTED" : "DISCONNECTED"}',
      );
      print(
        '📡 [ChatAppCubit] Current ConversationHub status: ${conversationHub.isConnected ? "CONNECTED" : "DISCONNECTED"}',
      );

      // Store the conversation ID before clearing
      final conversationId = currentConversationId;

      print('🔌 [ChatAppCubit] Disconnecting from ConversationHub...');
      await conversationHub.disconnect();
      print('✅ [ChatAppCubit] ConversationHub disconnected');

      // Always reconnect to GeneralHub to ensure fresh connection and event listeners
      print('🔄 [ChatAppCubit] Reconnecting to GeneralHub...');
      await generalHub.disconnect();
      await generalHub.connect(petId: petId, fullName: fullName, image: image);

      // Re-setup listeners after reconnection
      print('🎧 [ChatAppCubit] Re-registering GeneralHub listeners...');
      _setupGeneralHubListeners();
      _listenToGeneralEvents();
      print(
        '✅ [ChatAppCubit] GeneralHub reconnected and listeners re-registered',
      );

      // Refresh data from GeneralHub
      print('🔄 [ChatAppCubit] Refreshing online friends and unread counts...');
      await _loadInitialData();
      print('✅ [ChatAppCubit] Data refreshed successfully');
      print('📊 [ChatAppCubit] Online friends: $onlineFriends');
      print('📊 [ChatAppCubit] Unread counts: $unreadCounts');

      print(
        '📊 [ChatAppCubit] Active connections: GeneralHub=✓, ConversationHub=✗',
      );

      currentConversationId = null;
      currentUserId = null;

      // Emit state to trigger UI update
      emit(ConversationLeft());
      // Emit connected state to update UI indicators
      emit(ChatAppConnected());

      print('🎉 [ChatAppCubit] Successfully left conversation');
      print('────────────────────────────────────────');
    } catch (e) {
      print('❌ [ChatAppCubit] Error leaving conversation: $e');
      emit(ChatAppError('Failed to leave conversation: $e'));
    }
  }

  void _startPeriodicPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await Future.wait([_pollUnreadCounts(), _pollOnlineFriends()]);
    });
  }

  Future<void> _pollUnreadCounts() async {
    try {
      print(
        '🔍 [ChatAppCubit] Calling getUnreadMessageCounts for petId: $petId',
      );
      final counts = await generalHub.getUnreadMessageCounts(petId);

      print('📊 [ChatAppCubit] ═══════════════════════════════════');
      print('📊 [ChatAppCubit] GetUnreadMessageCounts Response:');
      print('   - Type: ${counts.runtimeType}');
      print('   - Is null: ${counts == null}');
      print('   - Count of conversations: ${counts?.length ?? 0}');
      print('   - Full response: $counts');
      if (counts != null) {
        counts.forEach((conversationId, count) {
          print('   - Conversation[$conversationId]: $count unread messages');
        });
      }
      print('📊 [ChatAppCubit] ═══════════════════════════════════');

      if (counts != null) {
        final newTotal = counts.values.fold(0, (sum, count) => sum + count);
        final oldTotal = _totalUnreadMessages;

        print(
          '📈 [ChatAppCubit] Unread totals - Old: $oldTotal, New: $newTotal',
        );
        print('📋 [ChatAppCubit] Previous unread counts: $unreadCounts');

        // Check if any conversation has new unread messages
        bool hasNewMessages = false;
        for (var conversationId in counts.keys) {
          final oldCount = unreadCounts[conversationId] ?? 0;
          final newCount = counts[conversationId] ?? 0;
          if (newCount > oldCount) {
            print(
              '🔔 [ChatAppCubit] New message in conversation $conversationId: $oldCount -> $newCount',
            );
            hasNewMessages = true;
          }
        }

        // Update unread counts
        unreadCounts = counts;
        emit(UnreadCountsPolled(counts));

        // Emit new message detected if any conversation has new messages
        if (hasNewMessages || newTotal > oldTotal) {
          print(
            '🔔 [ChatAppCubit] New message detected! Triggering chat list reload',
          );
          _totalUnreadMessages = newTotal;
          emit(NewMessageDetected());
        } else {
          _totalUnreadMessages = newTotal;
        }
      }
    } catch (e) {
      print('❌ [ChatAppCubit] Failed to poll unread counts: $e');
    }
  }

  Future<void> _pollOnlineFriends() async {
    try {
      print('🔍 [ChatAppCubit] Polling online friends for petId: $petId');
      final friends = await generalHub.getAllMyOnlinePetFriends(petId);

      print('📡 [ChatAppCubit] GetAllMyOnlinePetFriends result:');
      print('   - Result type: ${friends.runtimeType}');
      print('   - Is null: ${friends == null}');
      print('   - Is empty: ${friends?.isEmpty ?? true}');
      print('   - Count: ${friends?.length ?? 0}');

      if (friends != null) {
        print('   - Full result: $friends');
        for (var i = 0; i < friends.length; i++) {
          final friend = friends[i];
          print(
            '   - Friend[$i]: petId=${friend.petId}, isOnline=${friend.isOnline}, fullName=${friend.fullName}',
          );
        }

        // Create a new map to track online status
        final newOnlineStatus = <String, bool>{};

        // Check for friends that went offline (were in old map but not in new list)
        final currentOnlinePetIds = friends.map((f) => f.petId).toSet();
        for (var petId in onlineFriends.keys) {
          if (!currentOnlinePetIds.contains(petId) &&
              onlineFriends[petId] == true) {
            print('🔄 [ChatAppCubit] Friend $petId went offline');
            emit(FriendOnlineStatusChanged(petId, false));
          }
        }

        // Process current online friends
        for (var friend in friends) {
          final friendPetId = friend.petId;
          if (friendPetId.isNotEmpty) {
            newOnlineStatus[friendPetId] = friend.isOnline;

            // Check if status changed
            final wasOnline = onlineFriends[friendPetId] ?? false;
            if (wasOnline != friend.isOnline) {
              print(
                '🔄 [ChatAppCubit] Friend $friendPetId status changed: $wasOnline -> ${friend.isOnline}',
              );
              emit(FriendOnlineStatusChanged(friendPetId, friend.isOnline));
            }
          }
        }

        // Update the online friends map (will be empty if no friends online)
        onlineFriends = newOnlineStatus;
        print('✅ [ChatAppCubit] Updated online friends map: $onlineFriends');
      } else {
        print('⚠️ [ChatAppCubit] GetAllMyOnlinePetFriends returned null');
      }
    } catch (e) {
      print('❌ [ChatAppCubit] Failed to poll online friends: $e');
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
    print(
      '📡 [ChatAppCubit] GeneralHub status: ${generalHub.isConnected ? "CONNECTED" : "DISCONNECTED"}',
    );
    print(
      '📡 [ChatAppCubit] ConversationHub status: ${conversationHub.isConnected ? "CONNECTED" : "DISCONNECTED"}',
    );

    print('⏰ [ChatAppCubit] Stopping periodic polling...');
    _pollingTimer?.cancel();
    print('✅ [ChatAppCubit] Polling timer cancelled');

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
