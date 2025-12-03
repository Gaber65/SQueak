import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
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
  final Logger _logger = Logger('GeneralHub');

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
      _logger.severe('No authentication token found');
      throw Exception('No authentication token found');
    }


    if (isConnected) {
      _logger.info('Already connected to GeneralHub');
      _connectionStateController.add(true);
      return;
    }

    try {
      _logger.info('Connecting to GeneralHub for petId: $petId');
      
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
        _connectionStateController.add(true);
      });

      await _connection!.start();
      _registerEvents();
      _connectionStateController.add(true);
      _logger.info('✅ Connected to GeneralHub. ConnectionId: ${_connection!.connectionId}');
    } catch (e, stackTrace) {
      _logger.severe('Failed to connect to GeneralHub: $e\n$stackTrace');
      _connectionStateController.add(false);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_connection == null) return;
    
    _logger.info('Disconnecting from GeneralHub...');
    await _connection!.stop();
    _connectionStateController.add(false);
    _connection = null;
    _logger.info('Disconnected from GeneralHub');
  }

  void _registerEvents() {
    if (_connection == null) return;

    _logger.info('Registering GeneralHub event listeners...');

    // Event 1: ConnectionRegistered - Server confirms connection
    _connection!.on("ConnectionRegistered", (arguments) {
      _logger.fine('Event received: ConnectionRegistered - $arguments');
      signalEventStream.add(
        SignalEvent("GeneralHub", "ConnectionRegistered", arguments),
      );
    });

    // Event 2: FriendConnectionChanged - Friend online/offline status
    _connection!.on("FriendConnectionChanged", (arguments) {
      _logger.fine('Event received: FriendConnectionChanged - $arguments');
      signalEventStream.add(
        SignalEvent("GeneralHub", "FriendConnectionChanged", arguments),
      );
    });

    // Event 3: UnreadedMessagesCountPetConversation - Unread message counts
    _connection!.on("UnreadedMessagesCountPetConversation", (arguments) {
      _logger.fine('Event received: UnreadedMessagesCountPetConversation - $arguments');
      signalEventStream.add(
        SignalEvent(
            "GeneralHub", "UnreadedMessagesCountPetConversation", arguments),
      );
    });

    // Event 4: FriendIsTyping - Typing indicator
    _connection!.on("FriendIsTyping", (arguments) {
      _logger.fine('Event received: FriendIsTyping - $arguments');
      signalEventStream.add(
        SignalEvent("GeneralHub", "FriendIsTyping", arguments),
      );
    });
    
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

// SignalR GeneralHub Service

class SignalRGeneralHubService {
  static final SignalRGeneralHubService _instance =
      SignalRGeneralHubService._internal();
  factory SignalRGeneralHubService() => _instance;
  SignalRGeneralHubService._internal() {
    _setupLogging();
  }
  
  final _GeneralHubManager _hub = _GeneralHubManager();
  final Logger _logger = Logger('SignalRGeneralHubService');

  /// Setup logging configuration for SignalR
  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
    });
  }

  Stream<bool> get connectionStream => _hub.connectionStream;
  bool get isConnected => _hub.isConnected;
  String? get connectionId => _hub.connectionId;

  Future<void> connect({
    required String petId,
    String? fullName,
    String? image,
  }) async {
    _logger.info('Connecting to GeneralHub...');
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
      _logger.warning('Cannot get online friends: Not connected to GeneralHub');
      throw Exception('Not connected to GeneralHub');
    }

    try {
      _logger.info('Getting all online pet friends for petId: $petId');
      final result = await _hub.invoke<List<dynamic>>(
        "GetAllMyOnlinePetFriends",
        args: [petId],
      );

      if (result == null || result.isEmpty) {
        _logger.info('No online friends found');
        return [];
      }

      final friends = result
          .map((item) => PetConnectionDto.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
      
      _logger.info('Found ${friends.length} online friends');
      return friends;
    } catch (e, stackTrace) {
      _logger.severe('Error getting online friends: $e\n$stackTrace');
      return null;
    }
  }

  Future<void> setTypingIndicator({
    required String toPetId,
    required bool isTyping,
  }) async {
    if (!isConnected) {
      _logger.warning('Cannot set typing indicator: Not connected to GeneralHub');
      throw Exception('Not connected to GeneralHub');
    }

    _logger.fine('Setting typing indicator for $toPetId: $isTyping');
    await _hub.invoke<void>(
      "SetTypingIndicator",
      args: [toPetId, isTyping],
    );
  }

  Future<bool?> isPetOnline(String petId) async {
    if (!isConnected) {
      _logger.warning('Cannot check pet online status: Not connected to GeneralHub');
      throw Exception('Not connected to GeneralHub');
    }

    _logger.fine('Checking if pet $petId is online');
    return await _hub.invoke<bool>(
      "IsPetOnline",
      args: [petId],
    );
  }

  Future<Map<String, int>?> getUnreadMessageCounts(String petId) async {
    if (!isConnected) {
      _logger.warning('Cannot get unread message counts: Not connected to GeneralHub');
      throw Exception('Not connected to GeneralHub');
    }

    try {
      _logger.info('Getting unread message counts for petId: $petId');
      final result = await _hub.invoke<Map<dynamic, dynamic>>(
        "GetUnreadMessageCounts",
        args: [petId],
      );

      if (result == null) {
        _logger.info('No unread message counts found');
        return null;
      }

      final counts = result.map(
        (key, value) => MapEntry(key.toString(), value as int),
      );
      
      _logger.info('Unread message counts: $counts');
      return counts;
    } catch (e, stackTrace) {
      _logger.severe('Error getting unread message counts: $e\n$stackTrace');
      return null;
    }
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
