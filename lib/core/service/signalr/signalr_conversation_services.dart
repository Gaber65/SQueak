import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

// ============================================================================
// Event Models
// ============================================================================

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

// ============================================================================
// ConversationHub Manager
// ============================================================================

class _ConversationHubManager {
  HubConnection? _connection;
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionStateController.stream;
  bool get isConnected => _connection?.state == HubConnectionState.Connected;
  String? get connectionId => _connection?.connectionId;

  Future<void> connect({
    required String conversationId,
    required String petId,
  }) async {
    final token = CacheHelper.getData('token');
    if (token == null) {
      throw Exception('No authentication token found');
    }

    if (isConnected) {
      _connectionStateController.add(true);
      return;
    }

    try {
      final urlWithParams =
          '$conversationHubEndPoint?conversationId=$conversationId&petId=$petId';

      _connection = HubConnectionBuilder()
          .withUrl(
            urlWithParams,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token.toString(),
              transport: HttpTransportType.WebSockets,
            ),
          )
          .withAutomaticReconnect()
          .build();

      _connection!.onclose(({error}) {
        _connectionStateController.add(false);
      });

      _connection!.onreconnecting(({error}) {
        _connectionStateController.add(false);
      });

      _connection!.onreconnected(({connectionId}) {
        _connectionStateController.add(true);
      });

      await _connection!.start();
      _registerEvents();
      _connectionStateController.add(true);
    } catch (e) {
      _connectionStateController.add(false);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_connection == null) return;
    await _connection!.stop();
    _connectionStateController.add(false);
    _connection = null;
  }

  void _registerEvents() {
    if (_connection == null) return;

    _connection!.on("PetIsJoinedToConversation", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent(
            "ConversationHub", "PetIsJoinedToConversation", arguments),
      );
    });

    // Event 2: PetLeftConversation - Pet left the conversation
    _connection!.on("PetLeftConversation", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent(
            "ConversationHub", "PetLeftConversation", arguments),
      );
    });

    // Event 3: FriendIsTyping - Typing indicator in conversation
    _connection!.on("FriendIsTyping", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent("ConversationHub", "FriendIsTyping", arguments),
      );
    });

    // Event 4: ReceiveMessage - New message received
    _connection!.on("ReceiveMessage", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent("ConversationHub", "ReceiveMessage", arguments),
      );
    });

    // Event 5: ReadMessage - Message was read
    _connection!.on("ReadMessage", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent("ConversationHub", "ReadMessage", arguments),
      );
    });

    // Event 6: MessageIsRead - Confirmation that message is read
    _connection!.on("MessageIsRead", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent("ConversationHub", "MessageIsRead", arguments),
      );
    });

    // Event 7: MessageSentAndPetIsNotOnline - Message sent but recipient offline
    _connection!.on("MessageSentAndPetIsNotOnline", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent(
            "ConversationHub", "MessageSentAndPetIsNotOnline", arguments),
      );
    });

    // Event 8: MessageSentAndNotReadYet - Message sent but not read yet
    _connection!.on("MessageSentAndNotReadYet", (arguments) {
      conversationSignalEventStream.add(
        ConversationSignalEvent(
            "ConversationHub", "MessageSentAndNotReadYet", arguments),
      );
    });
  }

  Future<T?> invoke<T>(String methodName, {List<Object?>? args}) async {
    if (!isConnected) {
      throw Exception('Hub is not connected. Call connect() first.');
    }

    if (_connection == null) return null;

    try {
      final result = await _connection!.invoke(
        methodName,
        args: args?.cast<Object>(),
      );
      return result as T?;
    } catch (e) {
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
  SignalRConversationHubService._internal();

  final _ConversationHubManager _hub = _ConversationHubManager();


  Stream<bool> get connectionStream => _hub.connectionStream;
  bool get isConnected => _hub.isConnected;
  String? get connectionId => _hub.connectionId;


  Future<void> connect({
    required String conversationId,
    required String petId,
  }) async {
    await _hub.connect(
      conversationId: conversationId,
      petId: petId,
    );
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
      throw Exception('Not connected to ConversationHub');
    }

    await _hub.invoke<void>(
      "SetTyping",
      args: [conversationId, petId, isTyping],
    );
  }

  Future<void> sendMessageToUser(Map<String, dynamic> command) async {
    if (!isConnected) {
      throw Exception('Not connected to ConversationHub');
    }

    await _hub.invoke<void>(
      "SendMessageToUser",
      args: [command],
    );
  }

  Future<void> markAllUnreadedMessagesInConversationAsRead({
    required String conversationId,
    required String petId,
  }) async {
    if (!isConnected) {
      throw Exception('Not connected to ConversationHub');
    }

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
      throw Exception('Not connected to ConversationHub');
    }

    final result = await _hub.invoke<List<dynamic>>(
      "GetUnreadMessageIds",
      args: [conversationId, petId],
    );

    if (result == null) return null;

    return result.map((item) => item.toString()).toList();
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


  void onReceiveMessage(Function(Map<String, dynamic> data) callback) {
    _hub.on("ReceiveMessage", (args) {
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
      Function(Map<String, dynamic> data) callback) {
    _hub.on("MessageSentAndPetIsNotOnline", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onMessageSentAndNotReadYet(
      Function(Map<String, dynamic> data) callback) {
    _hub.on("MessageSentAndNotReadYet", (args) {
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
