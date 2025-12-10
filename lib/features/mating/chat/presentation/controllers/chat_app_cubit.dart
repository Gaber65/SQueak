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
  StreamSubscription? _onlineStatusSubscription; // الاستماع لتحديثات القاموس
  Timer? _pollingTimer;

  // تم إزالة onlineFriends المحلي - نستخدم القاموس من generalHub مباشرة
  // Removed local onlineFriends - using dictionary from generalHub directly
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
    print(
      '🚀 [ChatAppCubit] ══════════════════════════════════════════════════════════════',
    );
    print('🚀 [ChatAppCubit] بدء التهيئة لـ petId: $petId');
    print('🚀 [ChatAppCubit] Initializing for petId: $petId');
    emit(ChatAppLoading());

    try {
      print('🔌 [ChatAppCubit] الاتصال بـ GeneralHub...');
      print('🔌 [ChatAppCubit] Connecting to GeneralHub...');

      // الاتصال بـ GeneralHub (سيقوم تلقائياً بجلب قائمة الأصدقاء المتصلين)
      // Connect to GeneralHub (will automatically fetch online friends)
      await generalHub.connect(petId: petId, fullName: fullName, image: image);

      print('✅ [ChatAppCubit] تم الاتصال بـ GeneralHub بنجاح');
      print('✅ [ChatAppCubit] GeneralHub connected successfully');

      // الاستماع لتحديثات القاموس في الخلفية
      // Listen to dictionary updates in background
      print(
        '🎧 [ChatAppCubit] بدء الاستماع لتحديثات حالة الاتصال من القاموس...',
      );
      print(
        '🎧 [ChatAppCubit] Starting to listen to online status updates from dictionary...',
      );
      _listenToOnlineStatusUpdates();

      // Setup event listeners
      print('🎧 [ChatAppCubit] إعداد مستمعي أحداث GeneralHub...');
      print('🎧 [ChatAppCubit] Setting up GeneralHub listeners...');
      _setupGeneralHubListeners();
      _listenToGeneralEvents();

      print('✅ [ChatAppCubit] تم تكوين مستمعي GeneralHub');
      print('✅ [ChatAppCubit] GeneralHub listeners configured');

      // Get initial data
      print(
        '📥 [ChatAppCubit] تحميل البيانات الأولية (عدد الرسائل غير المقروءة)...',
      );
      print(
        '📥 [ChatAppCubit] Loading initial data (online friends & unread counts)...',
      );
      await _loadInitialData();

      print('✅ [ChatAppCubit] تم تحميل البيانات الأولية');
      print('✅ [ChatAppCubit] Initial data loaded');

      // Periodic polling for unread messages is disabled to avoid frequent server calls
      // If you need to re-enable, call `_startPeriodicPolling()` or implement a different trigger
      print('⏸️ [ChatAppCubit] الاستطلاع الدوري معطل');
      print('⏸️ [ChatAppCubit] Periodic polling disabled');

      emit(ChatAppConnected());
      print('🎉 [ChatAppCubit] اكتمل التهيئة - GeneralHub نشط');
      print('🎉 [ChatAppCubit] Initialization complete - GeneralHub is active');
      print(
        '🚀 [ChatAppCubit] ══════════════════════════════════════════════════════════════',
      );
    } catch (e) {
      print('❌ [ChatAppCubit] فشل التهيئة: $e');
      print('❌ [ChatAppCubit] Failed to initialize: $e');
      emit(ChatAppError('Failed to initialize: $e'));
    }
  }

  void _setupGeneralHubListeners() {
    // Connection registered
    generalHub.onConnectionRegistered((data) {
      print('✅ [ChatAppCubit] تسجيل الاتصال: $data');
      print('✅ [ChatAppCubit] Connection Registered: $data');
      emit(ConnectionRegistered(data));
    });

    // Friend connection changed - لم نعد نحتاج لمعالجته هنا، القاموس يتعامل معه
    // Friend connection changed - no longer need to handle here, dictionary handles it
    generalHub.onFriendConnectionChanged((data) {
      final friendPetId = data['PetId'] as String?;
      final isOnline = data['IsOnline'] as bool? ?? false;

      if (friendPetId != null) {
        print(
          '🔄 [ChatAppCubit] تغيير اتصال صديق: $friendPetId -> ${isOnline ? "متصل" : "غير متصل"}',
        );
        print(
          '🔄 [ChatAppCubit] Friend $friendPetId online status changed to: $isOnline',
        );

        // القاموس في generalHub تم تحديثه بالفعل تلقائياً
        // Dictionary in generalHub is already updated automatically
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
      print('📡 General Event: ${event.method} -> ${event.data}');

      // Handle UnreadedMessagesCountPetConversation event from stream
      if (event.method == 'UnreadedMessagesCountPetConversation') {
        try {
          if (event.data != null && event.data!.isNotEmpty) {
            final data = Map<String, dynamic>.from(event.data![0] as Map);
            final conversationId =
                (data['ConversationId'] ?? data['conversationId']) as String?;
            final count = (data['Count'] ?? data['count']) as int? ?? 0;

            print(
              '📬 [GeneralHub Stream] Unread count event - ConversationId: $conversationId, Count: $count',
            );

            if (conversationId != null) {
              unreadCounts[conversationId] = count;
              print(
                '📊 [GeneralHub Stream] Updated unreadCounts: $unreadCounts',
              );
              emit(UnreadCountUpdated(conversationId, count));
            }
          }
        } catch (e) {
          print(
            '❌ [GeneralHub Stream] Error processing unread count event: $e',
          );
        }
      }
    });
  }

  /// الاستماع لتحديثات القاموس من generalHub (عمل في الخلفية)
  /// Listen to dictionary updates from generalHub (background job)
  void _listenToOnlineStatusUpdates() {
    _onlineStatusSubscription?.cancel();

    _onlineStatusSubscription = generalHub.onlineStatusStream.listen((
      statusMap,
    ) {
      print(
        '📡 [ChatAppCubit] ══════════════════════════════════════════════════════════',
      );
      print('📡 [ChatAppCubit] تلقي تحديث القاموس من الخلفية');
      print('📡 [ChatAppCubit] Received dictionary update from background');
      print(
        '📡 [ChatAppCubit] إجمالي الأصدقاء في القاموس: ${statusMap.length}',
      );
      print(
        '📡 [ChatAppCubit] Total friends in dictionary: ${statusMap.length}',
      );
      print('📡 [ChatAppCubit] محتوى القاموس: $statusMap');
      print('📡 [ChatAppCubit] Dictionary content: $statusMap');

      // يمكن إصدار حدث لتحديث الواجهة إذا لزم الأمر
      // Can emit event to update UI if needed
      emit(ChatAppConnected()); // Force UI rebuild with new dictionary data

      print(
        '📡 [ChatAppCubit] ══════════════════════════════════════════════════════════',
      );
    });

    print('🎧 [ChatAppCubit] تم الاشتراك في تحديثات القاموس');
    print('🎧 [ChatAppCubit] Subscribed to dictionary updates');
  }

  Future<void> _loadInitialData() async {
    try {
      // لم نعد نحتاج لجلب الأصدقاء المتصلين - القاموس يحتوي عليهم بالفعل
      // No longer need to fetch online friends - dictionary already has them
      print(
        '📊 [ChatAppCubit] تخطي جلب الأصدقاء المتصلين - القاموس يحتوي عليهم بالفعل',
      );
      print(
        '📊 [ChatAppCubit] Skipping online friends fetch - dictionary already has them',
      );
      print(
        '📊 [ChatAppCubit] الأصدقاء المتصلين من القاموس: ${generalHub.onlineFriendsDict.length}',
      );
      print(
        '📊 [ChatAppCubit] Online friends from dictionary: ${generalHub.onlineFriendsDict.length}',
      );
      print('📊 [ChatAppCubit] محتوى القاموس: ${generalHub.onlineFriendsDict}');
      print(
        '📊 [ChatAppCubit] Dictionary content: ${generalHub.onlineFriendsDict}',
      );

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
        // Emit to trigger UI update
        emit(UnreadCountsPolled(counts));
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

    // Unread messages count update (fired after marking messages as read)
    conversationHub.onUnreadedMessagesCountPetConversation((data) {
      print('📬 [ConversationHub] UnreadedMessagesCountPetConversation: $data');
      final conversationId =
          (data['ConversationId'] ?? data['conversationId']) as String?;
      final count = (data['Count'] ?? data['count']) as int? ?? 0;

      if (conversationId != null) {
        unreadCounts[conversationId] = count;
        print(
          '📊 [ConversationHub] Updated unreadCounts[$conversationId] = $count',
        );
        emit(UnreadCountUpdated(conversationId, count));
      }
    });

    // // All messages marked as read (server sends this after markAllUnreadedMessagesInConversationAsRead)
    // conversationHub.onAllMessagesRead((data) {
    //   print('📖 [ConversationHub] AllMessagesRead event received: $data');
    //   if (currentConversationId != null) {
    //     unreadCounts[currentConversationId!] = 0;
    //     print(
    //       '📊 [ConversationHub] Set unreadCounts[$currentConversationId] = 0',
    //     );
    //     emit(UnreadCountUpdated(currentConversationId!, 0));
    //   }
    // });
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
      unreadCounts[conversationId] = 0;
      print(
        '📖 [ChatAppCubit] Marked messages as read, updating unread count to 0',
      );
      emit(UnreadCountUpdated(conversationId, 0));
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> leaveConversation() async {
    try {
      await conversationHub.disconnect();
      print('🔌 [ChatAppCubit] Disconnected from ConversationHub');
      print('📡 [ChatAppCubit] GeneralHub remains connected to receive events');
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

  /// فحص حالة الاتصال للصديق من القاموس المحلي (بدون استدعاء الخادم)
  /// Check if pet is online from local dictionary (without server call)
  Future<bool> checkIfPetOnline(String friendPetId) async {
    try {
      // استخدام القاموس المحلي بدلاً من استدعاء الخادم
      // Use local dictionary instead of server call
      final isOnline = generalHub.isPetOnlineFromDict(friendPetId);
      print(
        '🔍 [ChatAppCubit] فحص حالة الصديق $friendPetId من القاموس: ${isOnline ? "متصل" : "غير متصل"}',
      );
      print(
        '🔍 [ChatAppCubit] Checking friend $friendPetId from dictionary: ${isOnline ? "online" : "offline"}',
      );
      return isOnline;
    } catch (e) {
      print('❌ [ChatAppCubit] خطأ في فحص حالة الصديق: $e');
      print('❌ [ChatAppCubit] Error checking friend status: $e');
      return false;
    }
  }

  @override
  Future<void> close() async {
    print('🔴 [ChatAppCubit] إغلاق ChatAppCubit...');
    print('🔴 [ChatAppCubit] Closing ChatAppCubit...');

    _pollingTimer?.cancel();
    await _generalEventSubscription?.cancel();
    await _conversationEventSubscription?.cancel();
    await _onlineStatusSubscription?.cancel(); // إلغاء الاشتراك في القاموس
    await generalHub.disconnect();
    await conversationHub.disconnect();

    print('🔴 [ChatAppCubit] تم الإغلاق');
    print('🔴 [ChatAppCubit] Closed');
    return super.close();
  }
}
