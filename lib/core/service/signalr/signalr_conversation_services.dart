import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

final StreamController<ConversationSignalEvent> conversationSignalEventStream =
    StreamController<ConversationSignalEvent>.broadcast();

class ConversationSignalEvent {
  final String hub;
  final String method;
  final List<Object?>? data;

  ConversationSignalEvent(this.hub, this.method, this.data);

  @override
  String toString() => "[$hub] METHOD: $method → DATA: $data";
}

class _ConversationHubManager {
  HubConnection? _connection;
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();
  final Logger _logger = Logger('ConversationHub');
  bool _eventsRegistered = false;

  Stream<bool> get connectionStream => _connectionStateController.stream;
  bool get isConnected => _connection?.state == HubConnectionState.Connected;
  String? get connectionId => _connection?.connectionId;

  Future<void> connect({
    required String conversationId,
    required String petId,
  }) async {
    final token = CacheHelper.getData('token');
    if (token == null) {
      _logger.severe('No authentication token found');
      throw Exception('No authentication token found');
    }

    if (isConnected) {
      _logger.info('Already connected to ConversationHub');
      _connectionStateController.add(true);
      return;
    }

    try {
      _logger.info(
        'Connecting to ConversationHub for conversationId: $conversationId, petId: $petId',
      );

      final urlWithParams =
          '$conversationHubEndPoint?conversationId=$conversationId&petId=$petId';

      _connection =
          HubConnectionBuilder()
              .withUrl(
                urlWithParams,
                options: HttpConnectionOptions(
                  accessTokenFactory: () async => token.toString(),
                  transport: HttpTransportType.WebSockets,
                ),
              )
              .withAutomaticReconnect()
              .configureLogging(_logger)
              .build();

      _connection!.onclose(({error}) {
        _logger.warning('Connection closed. Error: $error');
        _connectionStateController.add(false);
      });

      _connection!.onreconnecting(({error}) {
        _logger.info('Reconnecting... Error: $error');
        _connectionStateController.add(false);
      });

      _connection!.onreconnected(({connectionId}) {
        _logger.info('✅ Reconnected successfully. ConnectionId: $connectionId');
        _registerEvents(); // Re-register events after reconnection
        _connectionStateController.add(true);
      });

      await _connection!.start();
      _registerEvents();
      _connectionStateController.add(true);
      _logger.info(
        '✅ Connected to ConversationHub. ConnectionId: ${_connection!.connectionId}',
      );
    } catch (e, stackTrace) {
      _logger.severe('Failed to connect to ConversationHub: $e\n$stackTrace');
      _connectionStateController.add(false);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_connection == null) return;

    _logger.info('Disconnecting from ConversationHub...');
    _eventsRegistered = false; // Reset flag
    await _connection!.stop();
    _connectionStateController.add(false);
    _connection = null;
    _logger.info('Disconnected from ConversationHub');
  }

  void _registerEvents() {
    if (_connection == null) {
      _logger.warning('⚠️ Cannot register events - connection is null');
      return;
    }

    if (_eventsRegistered) {
      _logger.info('ℹ️ Events already registered, skipping...');
      return;
    }

    _logger.info('🔧 Registering ConversationHub event listeners...');

    // Event 1: PetIsJoinedToConversation - Pet joined the conversation
    _connection!.on("PetIsJoinedToConversation", (arguments) {
      _logger.fine('Event received: PetIsJoinedToConversation - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent(
          "ConversationHub",
          "PetIsJoinedToConversation",
          arguments,
        ),
      );
    });

    // Event 2: PetLeftConversation - Pet left the conversation
    _connection!.on("PetLeftConversation", (arguments) {
      _logger.fine('Event received: PetLeftConversation - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent(
          "ConversationHub",
          "PetLeftConversation",
          arguments,
        ),
      );
    });

    // Event 3: FriendIsTyping - Typing indicator in conversation
    _connection!.on("FriendIsTyping", (arguments) {
      print('🎯 [ConversationHub] FriendIsTyping event received: $arguments');
      _logger.info('✅ Event received: FriendIsTyping - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent("ConversationHub", "FriendIsTyping", arguments),
      );
    });

    // Event 4: MessageReceived - New message received
    _connection!.on("MessageReceived", (arguments) {
      _logger.fine('Event received: MessageReceived - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent(
          "ConversationHub",
          "MessageReceived",
          arguments,
        ),
      );
    });

    // Event 5: ReadMessage - Message was read
    _connection!.on("ReadMessage", (arguments) {
      _logger.fine('Event received: ReadMessage - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent("ConversationHub", "ReadMessage", arguments),
      );
    });

    // Event 6: MessageIsRead - Confirmation that message is read
    _connection!.on("MessageIsRead", (arguments) {
      _logger.fine('Event received: MessageIsRead - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent("ConversationHub", "MessageIsRead", arguments),
      );
    });

    // Event 7: MessageSentAndPetIsNotOnline - Message sent but recipient offline
    _connection!.on("MessageSentAndPetIsNotOnline", (arguments) {
      _logger.fine('Event received: MessageSentAndPetIsNotOnline - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent(
          "ConversationHub",
          "MessageSentAndPetIsNotOnline",
          arguments,
        ),
      );
    });

    // Event 8: MessageSentAndNotReadYet - Message sent but not read yet
    _connection!.on("MessageSentAndNotReadYet", (arguments) {
      _logger.fine('Event received: MessageSentAndNotReadYet - $arguments');
      conversationSignalEventStream.add(
        ConversationSignalEvent(
          "ConversationHub",
          "MessageSentAndNotReadYet",
          arguments,
        ),
      );
    });

    // Event 9: UnreadedMessagesCountPetConversation - Unread message count update
    _connection!.on("UnreadedMessagesCountPetConversation", (arguments) {
      _logger.fine(
        'Event received: UnreadedMessagesCountPetConversation - $arguments',
      );
      conversationSignalEventStream.add(
        ConversationSignalEvent(
          "ConversationHub",
          "UnreadedMessagesCountPetConversation",
          arguments,
        ),
      );
    });

    _eventsRegistered = true;
    print('✅ [ConversationHub] All 9 event listeners registered successfully');
    _logger.info('✅ Event listeners registered successfully');
  }

  Future<T?> invoke<T>(String methodName, {List<Object?>? args}) async {
    if (!isConnected) {
      _logger.warning('Cannot invoke $methodName: Hub is not connected');
      throw Exception('Hub is not connected. Call connect() first.');
    }

    if (_connection == null) return null;

    try {
      _logger.info('Invoking method: $methodName with args: $args');
      final result = await _connection!.invoke(
        methodName,
        args: args?.cast<Object>(),
      );
      _logger.fine('Method $methodName executed successfully. Result: $result');
      return result as T?;
    } catch (e, stackTrace) {
      _logger.severe('Error invoking method $methodName: $e\n$stackTrace');
      return null;
    }
  }

  void on(String methodName, Function(List<Object?>?) callback) {
    if (_connection == null) return;
    _connection!.on(methodName, (args) {
      callback(args);
    });
  }

  void dispose() {
    _connectionStateController.close();
  }
}

class SignalRConversationHubService {
  static final SignalRConversationHubService _instance =
      SignalRConversationHubService._internal();
  factory SignalRConversationHubService() => _instance;
  SignalRConversationHubService._internal() {
    _setupLogging();
  }

  final _ConversationHubManager _hub = _ConversationHubManager();
  final Logger _logger = Logger('SignalRConversationHubService');

  /// Setup logging configuration for SignalR
  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
      );
    });
  }

  Stream<bool> get connectionStream => _hub.connectionStream;
  bool get isConnected => _hub.isConnected;
  String? get connectionId => _hub.connectionId;

  Future<void> connect({
    required String conversationId,
    required String petId,
  }) async {
    _logger.info('Connecting to ConversationHub...');
    await _hub.connect(conversationId: conversationId, petId: petId);
  }

  Future<void> disconnect() async {
    await _hub.disconnect();
  }

  Future<void> setTyping({
    required String conversationId,
    required String petId,
    required bool isTyping,
  }) async {
    if (!isConnected) {
      _logger.warning('Cannot set typing: Not connected to ConversationHub');
      throw Exception('Not connected to ConversationHub');
    }

    _logger.fine(
      'Setting typing indicator: conversationId=$conversationId, petId=$petId, isTyping=$isTyping',
    );
    await _hub.invoke<void>(
      "SetTyping",
      args: [conversationId, petId, isTyping],
    );
  }

  Future<void> sendMessageToUser(Map<String, dynamic> command) async {
    if (!isConnected) {
      _logger.warning('Cannot send message: Not connected to ConversationHub');
      throw Exception('Not connected to ConversationHub');
    }

    _logger.info('Sending message to user: $command');
    await _hub.invoke<void>("SendMessageToUser", args: [command]);
    _logger.fine('Message sent successfully');
  }

  Future<void> markAllUnreadedMessagesInConversationAsRead({
    required String conversationId,
    required String petId,
  }) async {
    if (!isConnected) {
      _logger.warning(
        'Cannot mark messages as read: Not connected to ConversationHub',
      );
      throw Exception('Not connected to ConversationHub');
    }

    _logger.info(
      'Marking all unread messages as read: conversationId=$conversationId, petId=$petId',
    );
    await _hub.invoke<void>(
      "MarkAllUnreadedMessagesInConversationAsRead",
      args: [conversationId, petId],
    );
  }

  Future<List<String>?> getUnreadMessageIds({
    required String conversationId,
    required String petId,
  }) async {
    if (!isConnected) {
      _logger.warning(
        'Cannot get unread message IDs: Not connected to ConversationHub',
      );
      throw Exception('Not connected to ConversationHub');
    }

    try {
      _logger.info(
        'Getting unread message IDs: conversationId=$conversationId, petId=$petId',
      );
      final result = await _hub.invoke<List<dynamic>>(
        "GetUnreadMessageIds",
        args: [conversationId, petId],
      );

      if (result == null) {
        _logger.info('No unread messages found');
        return null;
      }

      final messageIds = result.map((item) => item.toString()).toList();
      _logger.info('Found ${messageIds.length} unread messages');
      return messageIds;
    } catch (e, stackTrace) {
      _logger.severe('Error getting unread message IDs: $e\n$stackTrace');
      return null;
    }
  }

  void onPetJoinedToConversation(Function(Map<String, dynamic> data) callback) {
    _hub.on("PetIsJoinedToConversation", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onPetLeftConversation(Function(Map<String, dynamic> data) callback) {
    _hub.on("PetLeftConversation", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onFriendIsTyping(Function(Map<String, dynamic> data) callback) {
    _hub.on("FriendIsTyping", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onMessageReceived(Function(Map<String, dynamic> data) callback) {
    _hub.on("MessageReceived", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onReadMessage(Function(bool isRead) callback) {
    _hub.on("ReadMessage", (args) {
      if (args != null && args.isNotEmpty) {
        final isRead = args[0] as bool;
        callback(isRead);
      }
    });
  }

  void onMessageIsRead(Function(bool isRead) callback) {
    _hub.on("MessageIsRead", (args) {
      if (args != null && args.isNotEmpty) {
        final isRead = args[0] as bool;
        callback(isRead);
      }
    });
  }

  void onMessageSentAndPetIsNotOnline(
    Function(Map<String, dynamic> data) callback,
  ) {
    _hub.on("MessageSentAndPetIsNotOnline", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onMessageSentAndNotReadYet(
    Function(Map<String, dynamic> data) callback,
  ) {
    _hub.on("MessageSentAndNotReadYet", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onUnreadedMessagesCountPetConversation(
    Function(Map<String, dynamic> data) callback,
  ) {
    _hub.on("UnreadedMessagesCountPetConversation", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void dispose() {
    _hub.dispose();
  }
}
