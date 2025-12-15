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

  // Stream controller for typing indicators
  final StreamController<Map<String, bool>> _typingIndicatorsController =
      StreamController<Map<String, bool>>.broadcast();

  // Stream to listen to typing indicator changes
  Stream<Map<String, bool>> get typingIndicatorsStream =>
      _typingIndicatorsController.stream;

  // Stream controller for unread counts
  final StreamController<Map<String, int>> _unreadCountsController =
      StreamController<Map<String, int>>.broadcast();

  // Stream to listen to unread count changes
  Stream<Map<String, int>> get unreadCountsStream =>
      _unreadCountsController.stream;

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

    // Increase unread count (when recipient is online but not viewing conversation)
    generalHub.onIncreaseUnReadCount((data) {
      print('📥 [GeneralHub] ══════════════════════════════════════════════');
      print('📥 [GeneralHub] IncreaseUnReadCount event received!');
      print('📥 [GeneralHub] Raw data: $data');

      // Try both PascalCase and camelCase field names for compatibility
      final toPetId = (data['ToPetId'] ?? data['toPetId'])?.toString();
      final fromPetId = (data['FromPetId'] ?? data['fromPetId'])?.toString();
      final conversationId =
          (data['ConversationId'] ?? data['conversationId'])?.toString();
      final unreadCount =
          (data['UnReadCount'] ?? data['unReadCount']) as int? ?? 0;

      // Extract message content and type flags (new fields from server)
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
        print('📬 [GeneralHub] Processing unread count update');
        print('   Conversation ID: $conversationId');
        print('   From Pet: $fromPetId');
        print('   To Pet: $toPetId');
        print('   Server unread count: $unreadCount');
        print('   💬 Content: $contentMessage');
        print('   🖼️ Image Message: $imageMessage');
        print('   🎥 Video Message: $videoMessage');
        print('   📎 File Message: $fileMessage');
        print('   🎵 Audio Message: $audioMessage');

        // Use unread count directly from event (don't increment)
        unreadCounts[conversationId] = unreadCount;

        // Calculate total unread messages
        _totalUnreadMessages = unreadCounts.values.fold(
          0,
          (sum, count) => sum + count,
        );

        print('📊 Unread count from event: $unreadCount');
        print('📊 Updated unread counts map: $unreadCounts');
        print('📊 Total unread messages: $_totalUnreadMessages');
        print('📤 [GeneralHub] Emitting UnreadCountUpdated state');

        // Broadcast to stream for immediate UI update
        _unreadCountsController.add(Map.from(unreadCounts));

        emit(UnreadCountUpdated(conversationId, unreadCount));

        // Emit NewMessageDetected with message preview info
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

        print('✅ [GeneralHub] Unread count update complete');
      } else {
        print(
          '⚠️ [GeneralHub] IncreaseUnReadCount event missing ConversationId!',
        );
        print('   Available keys: ${data.keys.toList()}');
      }

      print('📥 [GeneralHub] ══════════════════════════════════════════════');
    });

    // Friend typing in general
    generalHub.onFriendIsTyping((data) {
      print('📥 [GeneralHub] Raw typing data: $data');
      print('📥 [GeneralHub] Data keys: ${data.keys.toList()}');
      print('📥 [GeneralHub] Data values: ${data.values.toList()}');

      final friendPetId = (data['PetId'] ?? data['petId']) as String?;
      final isTyping = (data['IsTyping'] ?? data['isTyping']) as bool? ?? false;
      final fromPetId = (data['FromPetId'] ?? data['fromPetId']) as String?;

      print('🔍 [GeneralHub] Extracted petId: $friendPetId');
      print('🔍 [GeneralHub] Extracted isTyping: $isTyping');

      if (friendPetId != null && friendPetId.isNotEmpty) {
        // Check if server is sending placeholder values
        if (friendPetId == 'fromPetId') {
          print(
            '❌ [GeneralHub] ERROR: Server is sending placeholder "fromPetId" instead of actual petId!',
          );
          print(
            '❌ [GeneralHub] This is a BACKEND BUG - the server must send actual GUID values',
          );
          print('❌ [GeneralHub] Full data received: $data');
        }

        typingIndicators[friendPetId] = isTyping;
        print(
          '⌨️ [GeneralHub] Friend $friendPetId typing status changed to: $isTyping',
        );
        print('📊 [GeneralHub] Current typing indicators: $typingIndicators');

        // Broadcast typing status to stream for real-time updates
        _typingIndicatorsController.add(Map.from(typingIndicators));

        emit(FriendTypingInGeneral(friendPetId, isTyping, fromPetId ?? ''));
      } else {
        print('⚠️ [GeneralHub] Typing event has empty petId!');
        print('⚠️ [GeneralHub] Available data: $data');
      }
    });

    generalHub.onMessagesDelivered((data) {
      print('📦 [GeneralHub] Messages delivered event: $data');
      final conversationId = data['ConversationId']?.toString();
      final deliveredToPetId = data['DeliveredToPetId']?.toString();

      if (conversationId != null) {
        print(
          '✅ [GeneralHub] رسائل المحادثة $conversationId تم توصيلها للمستقبِل $deliveredToPetId',
        );
        print(
          '✅ [GeneralHub] Messages in conversation $conversationId delivered to $deliveredToPetId',
        );

        // Emit event so UI can update message statuses
        // إرسال حدث لتحديث حالة الرسائل في الواجهة
        conversationSignalEventStream.add(
          ConversationSignalEvent('ConversationHub', 'MessagesDelivered', [
            data,
          ]),
        );
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

  // Track previous online status to detect changes
  final Map<String, bool> _lastOnlineStatus = {};

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

      // Check for status changes (Offline -> Online)
      for (final entry in statusMap.entries) {
        final friendId = entry.key;
        final isOnline = entry.value;
        final wasOnline = _lastOnlineStatus[friendId] ?? false;

        // Update local cache
        _lastOnlineStatus[friendId] = isOnline;

        // If user just came online (was offline/unknown -> is online)
        if (isOnline && !wasOnline) {
          print('🌟 [ChatAppCubit] Friend $friendId came ONLINE!');

          // If we are connected to ConversationHub, try to mark messages as delivered
          if (conversationHub.isConnected) {
            print(
              '🚀 [ChatAppCubit] Triggering markMessagesAsDelivered for $friendId',
            );
            markMessagesAsDelivered(friendId);
          }

          // Emit event so UI can react optimistically
          emit(FriendOnlineStatusChanged(friendId, true));
        }
      }

      print(
        '📡 [ChatAppCubit] إجمالي الأصدقاء في القاموس: ${statusMap.length}',
      );
      print(
        '📡 [ChatAppCubit] Total friends in dictionary: ${statusMap.length}',
      );

      // Update Unread Counts if we have data
      // This is important because sometimes initial unread counts might be missed
      // or if users come online, they might have read messages elsewhere

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
      print('👋 [ChatAppCubit] ═══════════════════════════════════════════');
      print('👋 [ChatAppCubit] المستخدم الآخر غادر المحادثة');
      print('👋 [ChatAppCubit] Other user left the conversation');
      print('👋 [ChatAppCubit] Data: $data');
      print(
        '👋 [ChatAppCubit] الرسائل الجديدة ستكون بحالة delivered وليس seen',
      );
      print('👋 [ChatAppCubit] New messages will be delivered, not seen');
      print('👋 [ChatAppCubit] ═══════════════════════════════════════════');
      emit(PetLeftConversation(data));
    });

    // Friend typing in conversation
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

    // Receive message (only incoming messages from other users)
    // استقبال الرسالة (فقط الرسائل الواردة من المستخدمين الآخرين)
    conversationHub.onMessageReceived((data) {
      var message = MessageModel.fromJson(data);

      // Only emit if this is an INCOMING message (toMe = true)
      // فقط إرسال الحدث إذا كانت رسالة واردة (toMe = true)
      if (message.toMe) {
        print('📥 [ChatAppCubit] Received INCOMING message from other user');
        emit(MessageReceived(currentConversationId!, message));
      } else {
        print(
          '📤 [ChatAppCubit] Ignoring OUTGOING message (already handled by MessageSent events)',
        );
      }
    });

    // Message is read
    conversationHub.onMessageIsRead((isRead) {
      if (isRead && currentConversationId != null) {
        emit(MessagesMarkedAsRead(currentConversationId!));
      }
    });

    // Single message read by recipient
    conversationHub.onSingleMessageRead((data) {
      print('📖 [ChatAppCubit] Single message read: $data');
      final messageId =
          data['MessageId']?.toString() ?? data['messageId']?.toString();
      if (messageId != null && currentConversationId != null) {
        emit(SingleMessageRead(currentConversationId!, messageId));
      }
    });

    // All messages in conversation read by recipient
    conversationHub.onAllMessagesReadInConversation((data) {
      print('📖📖 [ChatAppCubit] All messages read in conversation: $data');
      final conversationId =
          data['ConversationId']?.toString() ??
          data['conversationId']?.toString();
      if (conversationId != null) {
        unreadCounts[conversationId] = 0;
        emit(AllMessagesRead(conversationId));
      }
    });

    // // Message status changed
    // conversationHub.onMessageStatusChanged((data) {
    //   print('🔄 [ChatAppCubit] Message status changed: $data');
    //   final messageId =
    //       data['MessageId']?.toString() ?? data['messageId']?.toString();
    //   final isRead = data['IsRead'] ?? data['isRead'] ?? false;
    //   if (messageId != null) {
    //     emit(MessageStatusChanged(messageId, isRead));
    //   }
    // });

    // Message sent but recipient is not online
    // الرسالة تم إرسالها لكن المستلم غير متصل
    conversationHub.onMessageSentAndPetIsNotOnline((data) {
      final message = MessageModel.fromJson(data);

      print('🔵 [ChatAppCubit] ═══════════════════════════════════════════');
      print('🔵 [ChatAppCubit] الرسالة تم إرسالها - المستلم غير متصل');
      print('🔵 [ChatAppCubit] حالة الرسالة: MessageStatus.sent');
      print('🔵 [ChatAppCubit] messageId: ${message.id}');
      print('🔵 [ChatAppCubit] ═══════════════════════════════════════════');

      emit(MessageSentUnread(currentConversationId!, message));
    });

    // Message sent but not read yet (recipient online but not in chat)
    // الرسالة تم إرسالها لكن لم تُقرأ بعد (المستلم متصل لكن ليس في المحادثة)
    conversationHub.onMessageSentAndNotReadYet((data) {
      final message = MessageModel.fromJson(data);

      print('📬 [ChatAppCubit] ═══════════════════════════════════════════');
      print(
        '📬 [ChatAppCubit] الرسالة تم إرسالها - المستلم متصل لكن ليس في المحادثة',
      );
      print('📬 [ChatAppCubit] حالة الرسالة: MessageStatus.delivered');
      print('📬 [ChatAppCubit] messageId: ${message.id}');
      print('📬 [ChatAppCubit] ═══════════════════════════════════════════');

      // Call markMessagesAsDelivered since recipient is online but not in chat
      markMessagesAsDelivered(message.toUserId);

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

    // All messages marked as read (server sends this after markAllUnreadedMessagesInConversationAsRead)
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
      print('🔔 [ChatAppCubit] ══════════════════════════════════════════════');
      print(
        '🔔 [ChatAppCubit] Calling IncreaseUnReadCountMessageForConversation',
      );
      print('🔔 [ChatAppCubit] To Pet: $toPetId');
      print('🔔 [ChatAppCubit] From Pet: $fromPetId');
      print('🔔 [ChatAppCubit] Conversation: $conversationId');

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

      print('✅ [ChatAppCubit] Successfully increased unread message count');
      print('🔔 [ChatAppCubit] ══════════════════════════════════════════════');
    } catch (e) {
      print('❌ [ChatAppCubit] Error increasing unread message count: $e');
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

  Future<void> setTypingInGeneral({
    required String petId,
    required bool isTyping,
    required String fromPetId,
  }) async {
    try {
      // Send typing to general (for users in the chat)
      await generalHub.setTypingIndicator(
        toPetId: petId,
        isTyping: isTyping,
        fromPetId: this.petId,
      );

      print('⌨️ Setting typing indicator: isTyping=$isTyping');
    } catch (e) {
      print('Error setting typing: $e');
    }
  }

  Future<void> markMessagesAsDelivered(String toPetId) async {
    try {
      // التحقق من أن المستلم متصل لكن ليس في المحادثة الحالية
      final isOnline = generalHub.isPetOnlineFromDict(toPetId);

      print('📬 [ChatAppCubit] ═══════════════════════════════════════════');
      print('📬 [ChatAppCubit] تعليم الرسائل كـ "تم التوصيل"');
      print('📬 [ChatAppCubit] حالة الرسالة: MessageStatus.delivered');
      print('📬 [ChatAppCubit] المستلم ($toPetId) متصل: $isOnline');
      print('📬 [ChatAppCubit] المستلم ليس في المحادثة (لم يفتح الشات)');
      print('📬 [ChatAppCubit] ═══════════════════════════════════════════');

      if (isOnline) {
        await conversationHub.markMessagesAsDelivered(petId: toPetId);
        print('✅ [ChatAppCubit] تم تعليم الرسائل بنجاح كـ delivered');
      } else {
        print(
          '⚠️ [ChatAppCubit] المستلم غير متصل - لن يتم تعليم الرسائل كـ delivered',
        );
      }
    } catch (e) {
      print('❌ [ChatAppCubit] خطأ في تعليم الرسائل كـ delivered: $e');
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
    await _typingIndicatorsController.close();
    await _unreadCountsController.close();
    await generalHub.disconnect();
    await conversationHub.disconnect();

    print('🔴 [ChatAppCubit] تم الإغلاق');
    print('🔴 [ChatAppCubit] Closed');
    return super.close();
  }
}
