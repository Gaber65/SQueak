import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/features/mating/chat/domain/entities/online_entity.dart';

/// Broadcasts all SignalR events
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

/// Connection info model
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

/// GeneralHub manager
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

      // Lifecycle events
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

      // Start connection
      await _connection!.start();

      // Register all hub events
      _registerEvents();

      _connectionStateController.add(true);
      _logger.info(
          '✅ Connected to GeneralHub. ConnectionId: ${_connection!.connectionId}');
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

    void registerEvent(String eventName) {
      _connection!.on(eventName, (args) {
        print('📩 Event: $eventName -> $args');
        _logger.fine('Event received: $eventName - $args');
        signalEventStream.add(SignalEvent("GeneralHub", eventName, args));
      });
    }

    // Register all events you expect
    [
      "ConnectionRegistered",
      "FriendConnectionChanged",
      "UnreadedMessagesCountPetConversation",
      "FriendIsTyping",
    ].forEach(registerEvent);

    _logger.info('✅ Event listeners registered successfully');
  }

  Future<T?> invoke<T>(String methodName, {List<Object?>? args}) async {
    if (!isConnected) {
      _logger.warning('Cannot invoke $methodName: Hub is not connected');
      throw Exception('Hub is not connected. Call connect() first.');
    }

    if (_connection == null) return null;

    try {
      print('🟥 INVOKE: $methodName -> $args');
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
    _connection!.on(methodName, callback);
  }

  void dispose() {
    _connectionStateController.close();
  }
}

/// SignalR GeneralHub service
class SignalRGeneralHubService {
  static final SignalRGeneralHubService _instance =
  SignalRGeneralHubService._internal();
  factory SignalRGeneralHubService() => _instance;
  SignalRGeneralHubService._internal() {
    _setupLogging();
  }

  final _GeneralHubManager _hub = _GeneralHubManager();
  final Logger _logger = Logger('SignalRGeneralHubService');

  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
          '[${record.level.name}] [${record.loggerName}] ${record.time} => ${record.message}');
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
    await _hub.connect(petId: petId, fullName: fullName, image: image);
  }

  Future<void> disconnect() async => await _hub.disconnect();

  Future<List<PetConnectionDto>?> getAllMyOnlinePetFriends(String petId) async {
    if (!isConnected) {
      _logger.warning(
          'Cannot get online friends: Not connected to GeneralHub');
      throw Exception('Not connected to GeneralHub');
    }

    final result = await _hub.invoke<List<dynamic>>(
      "GetAllMyOnlinePetFriends",
      args: [petId],
    );

    if (result == null || result.isEmpty) return [];

    return result
        .map((item) => PetConnectionDto.fromJson(
        Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> setTypingIndicator(
      {required String toPetId, required bool isTyping}) async =>
      await _hub.invoke<void>("SetTypingIndicator", args: [toPetId, isTyping]);

  Future<bool?> isPetOnline(String petId) async =>
      await _hub.invoke<bool>("IsPetOnline", args: [petId]);

  Future<Map<String, int>?> getUnreadMessageCounts(String petId) async {
    final result =
    await _hub.invoke<Map<dynamic, dynamic>>("GetUnreadMessageCounts", args: [petId]);
    if (result == null) {
      print('⚠️ GetUnreadMessageCounts returned null for petId: $petId');
      return null;
    }
    final counts = result.map((k, v) => MapEntry(k.toString(), v as int));
    print('📊 GetUnreadMessageCounts result for petId $petId: $counts');
    return counts;
  }

  void onConnectionRegistered(Function(Map<String, dynamic>) callback) {
    _hub.on("ConnectionRegistered", (args) {
      if (args != null && args.isNotEmpty) {
        callback(Map<String, dynamic>.from(args[0] as Map));
      }
    });
  }

  void onFriendConnectionChanged(Function(Map<String, dynamic>) callback) {
    _hub.on("FriendConnectionChanged", (args) {
      if (args != null && args.isNotEmpty) {
        callback(Map<String, dynamic>.from(args[0] as Map));
      }
    });
  }

  void onUnreadedMessagesCount(Function(Map<String, dynamic>) callback) {
    _hub.on("UnreadedMessagesCountPetConversation", (args) {
      if (args != null && args.isNotEmpty) {
        callback(Map<String, dynamic>.from(args[0] as Map));
      }
    });
  }

  void onFriendIsTyping(Function(Map<String, dynamic>) callback) {
    _hub.on("FriendIsTyping", (args) {
      if (args != null && args.isNotEmpty) {
        callback(Map<String, dynamic>.from(args[0] as Map));
      }
    });
  }

  void dispose() => _hub.dispose();
}
