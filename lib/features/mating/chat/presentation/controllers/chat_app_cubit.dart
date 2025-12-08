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
      emit(PetLeftConversation(data));
    });

    // Friend typing in conversation
    conversationHub.onFriendIsTyping((data) {
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
      await conversationHub.disconnect();
      await generalHub.disconnect();
      await generalHub.connect(petId: petId, fullName: fullName, image: image);
      _setupGeneralHubListeners();
      _listenToGeneralEvents();

      // Refresh data from GeneralHub
      print('🔄 [ChatAppCubit] Refreshing online friends and unread counts...');
      await _loadInitialData();
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
    } catch (e) {
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
        if (hasNewMessages || newTotal > oldTotal) {
          _totalUnreadMessages = newTotal;
          emit(NewMessageDetected());
        } else {
          _totalUnreadMessages = newTotal;
        }
      }
    } catch (e) {}
  }

  Future<void> _pollOnlineFriends() async {
    try {
      final friends = await generalHub.getAllMyOnlinePetFriends(petId);

      if (friends != null) {
        final newOnlineStatus = <String, bool>{};
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
              emit(FriendOnlineStatusChanged(friendPetId, friend.isOnline));
            }
          }
        }

        onlineFriends = newOnlineStatus;
      } else {}
    } catch (e) {}
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
    _pollingTimer?.cancel();
    await _generalEventSubscription?.cancel();
    await _conversationEventSubscription?.cancel();
    await generalHub.disconnect();
    await conversationHub.disconnect();
    return super.close();
  }
}
