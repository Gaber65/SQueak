import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

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

/// DTO للأصدقاء المتصلين (PetConnectionDto)
class PetConnectionDto {
  final String petId;
  final String fullName;
  final String image;
  final bool isOnline;

  PetConnectionDto({
    required this.petId,
    required this.fullName,
    required this.image,
    required this.isOnline,
  });

  factory PetConnectionDto.fromJson(Map<String, dynamic> json) {
    return PetConnectionDto(
      petId: json['PetId'] ?? json['petId'] ?? '',
      fullName: json['FullName'] ?? json['fullName'] ?? '',
      image: json['Image'] ?? json['image'] ?? '',
      isOnline: json['IsOnline'] ?? json['isOnline'] ?? false,
    );
  }

  @override
  String toString() =>
      'PetConnectionDto(petId: $petId, fullName: $fullName, isOnline: $isOnline)';
}

/// حمولة تغيير الاتصال (ConnectionChangePayload)
class ConnectionChangePayload {
  final String petId;
  final bool isOnline;
  final String? connectionId;
  final DateTime? connectedAt;

  ConnectionChangePayload({
    required this.petId,
    required this.isOnline,
    this.connectionId,
    this.connectedAt,
  });

  factory ConnectionChangePayload.fromJson(Map<String, dynamic> json) {
    return ConnectionChangePayload(
      petId: json['PetId'] ?? json['petId'] ?? '',
      isOnline: json['IsOnline'] ?? json['isOnline'] ?? false,
      connectionId: json['ConnectionId'] ?? json['connectionId'],
      connectedAt:
          json['ConnectedAt'] != null
              ? DateTime.parse(json['ConnectedAt'] as String)
              : null,
    );
  }

  @override
  String toString() =>
      'ConnectionChangePayload(petId: $petId, isOnline: $isOnline)';
}

/// Connection info model (kept for backward compatibility)
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
      connectedAt:
          json['ConnectedAt'] != null
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

  // القاموس: تتبع حالة الاتصال لكل صديق (PetId -> IsOnline)
  // THE DICTIONARY: Stores PetId -> IsOnline status
  final Map<String, bool> _onlineFriendsDict = {};
  final StreamController<Map<String, bool>> _onlineStatusController =
      StreamController<Map<String, bool>>.broadcast();

  Stream<bool> get connectionStream => _connectionStateController.stream;
  Stream<Map<String, bool>> get onlineStatusStream =>
      _onlineStatusController.stream;
  Map<String, bool> get onlineFriendsDict =>
      Map.unmodifiable(_onlineFriendsDict);
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
        _registerEvents(); // Re-register events after reconnection
        _connectionStateController.add(true);
      });

      // Start connection
      await _connection!.start();

      // Register all hub events
      _registerEvents();

      _connectionStateController.add(true);
      _logger.info(
        'Connected to GeneralHub successfully. Connection ID: ${_connection!.connectionId}',
      );

      print(
        '🌍 [GeneralHub] ═══════════════════════════════════════════════════',
      );
      print('🌍 [GeneralHub] تم الاتصال بنجاح بـ GeneralHub');
      print('🌍 [GeneralHub] Successfully connected to GeneralHub');
      print('🌍 [GeneralHub] Connection ID: ${_connection!.connectionId}');
      print(
        '🌍 [GeneralHub] ═══════════════════════════════════════════════════',
      );

      // الخطوة الأولى: جلب قائمة الأصدقاء المتصلين
      // STEP 1: Fetch initial online friends list
      await _fetchInitialOnlineFriends(petId);
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

  /// جلب قائمة الأصدقاء المتصلين الأولية وملء القاموس
  /// Fetch initial online friends and populate the dictionary
  Future<void> _fetchInitialOnlineFriends(String petId) async {
    try {
      print('📡 [GeneralHub] ══════════════════════════════════════════');
      print('📡 [GeneralHub] جاري جلب قائمة الأصدقاء المتصلين الأولية...');
      print('📡 [GeneralHub] Fetching initial online friends list...');
      print('📡 [GeneralHub] Pet ID: $petId');

      final result = await invoke<List<dynamic>>(
        'GetAllMyOnlinePetFriends',
        args: [petId],
      );

      if (result != null && result.isNotEmpty) {
        print('✅ [GeneralHub] تم استلام ${result.length} صديق من الخادم');
        print('✅ [GeneralHub] Received ${result.length} friends from server');

        _onlineFriendsDict.clear();

        for (var item in result) {
          final friend = PetConnectionDto.fromJson(
            item as Map<String, dynamic>,
          );
          _onlineFriendsDict[friend.petId] = friend.isOnline;

          final statusAr = friend.isOnline ? 'متصل' : 'غير متصل';
          final statusEn = friend.isOnline ? 'Online' : 'Offline';
          print(
            '   👤 ${friend.fullName} (${friend.petId}): $statusAr / $statusEn',
          );
        }

        print(
          '📊 [GeneralHub] إجمالي الأصدقاء في القاموس: ${_onlineFriendsDict.length}',
        );
        print(
          '📊 [GeneralHub] Total friends in dictionary: ${_onlineFriendsDict.length}',
        );
        print('📊 [GeneralHub] Dictionary content: $_onlineFriendsDict');

        // بث التحديث للواجهة
        // Broadcast update to UI
        _onlineStatusController.add(_onlineFriendsDict);
        print('📢 [GeneralHub] تم بث حالة الاتصال الأولية للواجهة');
        print('📢 [GeneralHub] Initial status broadcasted to UI');
      } else {
        print('⚠️ [GeneralHub] لم يتم العثور على أصدقاء متصلين');
        print('⚠️ [GeneralHub] No online friends found');
      }

      print('📡 [GeneralHub] ══════════════════════════════════════════');
    } catch (e, stackTrace) {
      print('❌ [GeneralHub] خطأ في جلب الأصدقاء المتصلين: $e');
      print('❌ [GeneralHub] Error fetching online friends: $e');
      _logger.severe('Failed to fetch initial online friends: $e\n$stackTrace');
    }
  }

  void _registerEvents() {
    if (_connection == null) return;

    _logger.info('Registering GeneralHub event listeners...');

    // Unregister all handlers first to avoid duplicates
    _connection!.off("ConnectionRegistered");
    _connection!.off("FriendConnectionChanged");
    _connection!.off("UnreadedMessagesCountPetConversation");
    _connection!.off("FriendIsTyping");

    void registerEvent(String eventName) {
      _connection!.on(eventName, (args) {
        print('📩 [GeneralHub] Event: $eventName -> $args');
        _logger.fine('Event received: $eventName - $args');

        // معالجة خاصة لحدث تغيير الاتصال
        // Special handling for FriendConnectionChanged event
        if (eventName == 'FriendConnectionChanged' &&
            args != null &&
            args.isNotEmpty) {
          _handleFriendConnectionChanged(args[0]);
        }

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

    // Add catch-all handler for debugging (logs all unhandled events)
    _connection!.onclose(({error}) {
      print('🔴 [GeneralHub] الاتصال مغلق | Connection closed: $error');
    });

    _logger.info('✅ Event listeners registered successfully');
    print('🎧 [GeneralHub] تم تسجيل مستمعي الأحداث بنجاح');
    print('🎧 [GeneralHub] Event listeners registered successfully');
  }

  /// معالج حدث تغيير اتصال الصديق - يحدث القاموس في الخلفية
  /// Handler for FriendConnectionChanged event - updates dictionary in background
  void _handleFriendConnectionChanged(dynamic data) {
    try {
      print('🔄 [GeneralHub] ══════════════════════════════════════════');
      print('🔄 [GeneralHub] تلقي حدث تغيير اتصال الصديق');
      print('🔄 [GeneralHub] Received FriendConnectionChanged event');

      final payload = ConnectionChangePayload.fromJson(
        data as Map<String, dynamic>,
      );

      final oldStatus = _onlineFriendsDict[payload.petId];
      final statusChangedAr =
          oldStatus == null ? 'جديد' : (oldStatus ? 'متصل' : 'غير متصل');
      final statusChangedEn =
          oldStatus == null ? 'new' : (oldStatus ? 'online' : 'offline');
      final newStatusAr = payload.isOnline ? 'متصل' : 'غير متصل';
      final newStatusEn = payload.isOnline ? 'online' : 'offline';

      print('   📝 Pet ID: ${payload.petId}');
      print(
        '   📝 الحالة السابقة / Previous: $statusChangedAr / $statusChangedEn',
      );
      print('   📝 الحالة الجديدة / New: $newStatusAr / $newStatusEn');

      // تحديث القاموس
      // Update the dictionary
      _onlineFriendsDict[payload.petId] = payload.isOnline;

      print('✅ [GeneralHub] تم تحديث القاموس بنجاح');
      print('✅ [GeneralHub] Dictionary updated successfully');
      print('📊 [GeneralHub] حجم القاموس الحالي: ${_onlineFriendsDict.length}');
      print(
        '📊 [GeneralHub] Current dictionary size: ${_onlineFriendsDict.length}',
      );

      // بث التحديث للواجهة (عمل في الخلفية)
      // Broadcast update to UI (background job)
      _onlineStatusController.add(_onlineFriendsDict);

      print('📢 [GeneralHub] تم بث التحديث للواجهة في الخلفية');
      print('📢 [GeneralHub] Update broadcasted to UI in background');
      print('🔄 [GeneralHub] ══════════════════════════════════════════');
    } catch (e, stackTrace) {
      print('❌ [GeneralHub] خطأ في معالجة تغيير الاتصال: $e');
      print('❌ [GeneralHub] Error handling connection change: $e');
      _logger.severe('Error handling FriendConnectionChanged: $e\n$stackTrace');
    }
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
    _onlineStatusController.close();
    _onlineFriendsDict.clear();
  }

  /// التحقق من حالة صديق معين من القاموس
  /// Check if a specific friend is online from dictionary
  bool isPetOnlineFromDict(String petId) {
    final isOnline = _onlineFriendsDict[petId] ?? false;
    print(
      '🔍 [GeneralHub] فحص حالة $petId من القاموس: ${isOnline ? "متصل" : "غير متصل"}',
    );
    print(
      '🔍 [GeneralHub] Checking $petId status from dictionary: ${isOnline ? "online" : "offline"}',
    );
    return isOnline;
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
        '[${record.level.name}] [${record.loggerName}] ${record.time} => ${record.message}',
      );
    });
  }

  Stream<bool> get connectionStream => _hub.connectionStream;
  Stream<Map<String, bool>> get onlineStatusStream => _hub.onlineStatusStream;
  Map<String, bool> get onlineFriendsDict => _hub.onlineFriendsDict;
  bool get isConnected => _hub.isConnected;
  String? get connectionId => _hub.connectionId;

  /// التحقق من حالة صديق من القاموس المحلي (بدون استدعاء الخادم)
  /// Check friend status from local dictionary (without server call)
  bool isPetOnlineFromDict(String petId) => _hub.isPetOnlineFromDict(petId);

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
      _logger.warning('Cannot get online friends: Not connected to GeneralHub');
      throw Exception('Not connected to GeneralHub');
    }

    final result = await _hub.invoke<List<dynamic>>(
      "GetAllMyOnlinePetFriends",
      args: [petId],
    );

    if (result == null || result.isEmpty) return [];

    return result
        .map(
          (item) =>
              PetConnectionDto.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> setTypingIndicator({
    required String toPetId,
    required bool isTyping,
    required String fromPetId,
  }) async =>
      await _hub.invoke<void>("SetTypingIndicator", args: [ toPetId, isTyping,fromPetId]);

  Future<bool?> isPetOnline(String petId) async =>
      await _hub.invoke<bool>("IsPetOnline", args: [petId]);

  Future<Map<String, int>?> getUnreadMessageCounts(String petId) async {
    final result = await _hub.invoke<Map<dynamic, dynamic>>(
      "GetUnreadMessageCounts",
      args: [petId],
    );
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

  void onMessagesDelivered(Function(Map<String, dynamic>) callback) {
    _hub.on('MessagesDelivered', (args) {
      if (args != null && args.isNotEmpty) {
        final data = args[0] is Map<String, dynamic>
            ? args[0] as Map<String, dynamic>
            : <String, dynamic>{};
        signalEventStream.add(
          SignalEvent('GeneralHub', 'MessagesDelivered', args),
        );
        callback(data);
      }
    });
  }

  void dispose() => _hub.dispose();
}
