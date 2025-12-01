import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/features/mating/chat/domain/entities/online_entity.dart';



final StreamController<SignalEvent> signalEventStream =
    StreamController<SignalEvent>.broadcast();

class SignalEvent {
  final String hub;
  final String method;
  final List<Object?>? data;

  SignalEvent(this.hub, this.method, this.data);

  @override
  String toString() => "[$hub] METHOD: $method → DATA: $data";
}

// Connection Info Model


class ConnectionInfo {
  final String connectionId;
  final String petId;
  final String fullName;
  final String image;
  final bool isOnline;
  final DateTime connectedAt;

  ConnectionInfo({
    required this.connectionId,
    required this.petId,
    required this.fullName,
    required this.image,
    required this.isOnline,
    required this.connectedAt,
  });

  factory ConnectionInfo.fromJson(Map<String, dynamic> json) {
    return ConnectionInfo(
      connectionId: json['ConnectionId'] ?? '',
      petId: json['PetId'] ?? '',
      fullName: json['FullName'] ?? '',
      image: json['Image'] ?? '',
      isOnline: json['IsOnline'] ?? false,
      connectedAt: json['ConnectedAt'] != null
          ? DateTime.parse(json['ConnectedAt'])
          : DateTime.now(),
    );
  }
}

// GeneralHub Manager

class _GeneralHubManager {
  HubConnection? _connection;
  final StreamController<bool> _connectionStateController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionStateController.stream;
  bool get isConnected => _connection?.state == HubConnectionState.Connected;
  String? get connectionId => _connection?.connectionId;


  Future<void> connect({
    required String petId,
    String? fullName,
    String? image,
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
      // Build URL with query parameters
      final urlWithParams =
          '$generalHubEndPoint?petId=$petId&fullName=${fullName ?? ''}&image=${image ?? ''}';

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

    // Event 1: ConnectionRegistered - Server confirms connection
    _connection!.on("ConnectionRegistered", (arguments) {
      signalEventStream.add(
        SignalEvent("GeneralHub", "ConnectionRegistered", arguments),
      );
    });

    // Event 2: FriendConnectionChanged - Friend online/offline status
    _connection!.on("FriendConnectionChanged", (arguments) {
      signalEventStream.add(
        SignalEvent("GeneralHub", "FriendConnectionChanged", arguments),
      );
    });

    // Event 3: UnreadedMessagesCountPetConversation - Unread message counts
    _connection!.on("UnreadedMessagesCountPetConversation", (arguments) {
      signalEventStream.add(
        SignalEvent(
            "GeneralHub", "UnreadedMessagesCountPetConversation", arguments),
      );
    });

    // Event 4: FriendIsTyping - Typing indicator
    _connection!.on("FriendIsTyping", (arguments) {
      signalEventStream.add(
        SignalEvent("GeneralHub", "FriendIsTyping", arguments),
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

// SignalR GeneralHub Service

class SignalRGeneralHubService {
  static final SignalRGeneralHubService _instance =
      SignalRGeneralHubService._internal();
  factory SignalRGeneralHubService() => _instance;
  SignalRGeneralHubService._internal();
  final _GeneralHubManager _hub = _GeneralHubManager();



  Stream<bool> get connectionStream => _hub.connectionStream;
  bool get isConnected => _hub.isConnected;
  String? get connectionId => _hub.connectionId;

  Future<void> connect({
    required String petId,
    String? fullName,
    String? image,
  }) async {
    await _hub.connect(
      petId: petId,
      fullName: fullName,
      image: image,
    );
  }
  Future<void> disconnect() async {
    await _hub.disconnect();
  }

  Future<List<PetConnectionDto>?> getAllMyOnlinePetFriends(
    String petId,
  ) async {
    if (!isConnected) {
      throw Exception('Not connected to GeneralHub');
    }

    try {
      final result = await _hub.invoke<List<dynamic>>(
        "GetAllMyOnlinePetFriends",
        args: [petId],
      );

      if (result == null || result.isEmpty) return [];

      return result
          .map((item) => PetConnectionDto.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> setTypingIndicator({
    required String toPetId,
    required bool isTyping,
  }) async {
    if (!isConnected) {
      throw Exception('Not connected to GeneralHub');
    }

    await _hub.invoke<void>(
      "SetTypingIndicator",
      args: [toPetId, isTyping],
    );
  }

  Future<bool?> isPetOnline(String petId) async {
    if (!isConnected) {
      throw Exception('Not connected to GeneralHub');
    }

    return await _hub.invoke<bool>(
      "IsPetOnline",
      args: [petId],
    );
  }

  Future<Map<String, int>?> getUnreadMessageCounts(String petId) async {
    if (!isConnected) {
      throw Exception('Not connected to GeneralHub');
    }

    final result = await _hub.invoke<Map<dynamic, dynamic>>(
      "GetUnreadMessageCounts",
      args: [petId],
    );

    if (result == null) return null;

    return result.map(
      (key, value) => MapEntry(key.toString(), value as int),
    );
  }

  void onConnectionRegistered(
      Function(Map<String, dynamic> data) callback) {
    _hub.on("ConnectionRegistered", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onFriendConnectionChanged(
      Function(Map<String, dynamic> data) callback) {
    _hub.on("FriendConnectionChanged", (args) {
      if (args != null && args.isNotEmpty) {
        final data = Map<String, dynamic>.from(args[0] as Map);
        callback(data);
      }
    });
  }

  void onUnreadedMessagesCount(
      Function(Map<String, dynamic> data) callback) {
    _hub.on("UnreadedMessagesCountPetConversation", (args) {
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



  void dispose() {
    _hub.dispose();
  }
}
