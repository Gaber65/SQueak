import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

class SignalRService {
  static const String _hubUrl =
      'https://squeakapi.veticareapp.com:8001/chathub';

  HubConnection? _hubConnection;

  HubConnectionState get connectionState =>
      _hubConnection?.state ?? HubConnectionState.Disconnected;

  bool get isConnected => connectionState == HubConnectionState.Connected;
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  Future<void> connect() async {
    try {
      debugPrint('Starting SignalR connection...');
      final token = CacheHelper.getData('token');
      if (token == null || token.toString().isEmpty) {
        debugPrint('No token found - connection cancelled.');
        return;
      }
      debugPrint('✅ Token found: $token');
      if (_hubConnection != null && isConnected) {
        debugPrint(
          '✅ SignalR: Connection is already active - no need to reconnect.',
        );
        return;
      }

      if (_hubConnection != null && !isConnected) {
        debugPrint('reconnecting🔄');
        await disconnect();
      }
      debugPrint('🔧 SignalR: Create new instance');
      _hubConnection =
          HubConnectionBuilder()
              .withUrl(
                _hubUrl,
                options: HttpConnectionOptions(
                  accessTokenFactory: () async => token.toString(),
                  requestTimeout: 30000,
                  skipNegotiation: false,
                  transport: HttpTransportType.WebSockets,
                ),
              )
              .withAutomaticReconnect(
                retryDelays: [0, 2000, 5000, 10000, 30000],
              )
              .build();
      _registerConnectionEvents();

      debugPrint('🚀 SignalR: Try Connecting.');
      debugPrint('⏱️ SignalR: Maximum wait time: 30 seconds');
      await _hubConnection!.start();
      debugPrint('✅ SignalR: Connected!');
      debugPrint('📊 SignalR: Connection state: ${connectionState.toString()}');
      debugPrint('🆔 SignalR: Connection ID: ${connectionId ?? "Unavailable"}');
    } catch (e) {
      debugPrint('❌ SignalR: Connection failed - $e');

      if (e.toString().contains('TimeoutException')) {
        debugPrint('⚠️ SignalR: Server not responding - check:');
        debugPrint('   1. Internet connection');
        debugPrint('   2. Server URL correctness: $_hubUrl');
        debugPrint('   3. Server is running properly');
      } else if (e.toString().contains('SocketException')) {
        debugPrint('⚠️ SignalR: Network issue - check internet connection');
      }

      rethrow;
    }
  }

  void _registerConnectionEvents() {
    if (_hubConnection == null) return;
    _hubConnection!.onclose(({error}) {
      debugPrint('🔴 SignalR: Disconnect');
      if (error != null) {
        debugPrint('❌ SignalR: $error');
      }
    });

    _hubConnection!.onreconnecting(({error}) {
      debugPrint('🔄 SignalR: reconnecting...');
      if (error != null) {
        debugPrint('⚠️ SignalR: : $error');
      }
    });
    _hubConnection!.onreconnected(({connectionId}) {
      debugPrint('✅ SignalR: Recconected Successfully!');
      debugPrint('🆔 SignalR Id: : $connectionId');
    });
  }

  Future<void> sendMessageToUser(Map<String, dynamic> command) async {
    try {
      debugPrint('📤 SignalR: Try Send Message..');
      if (!isConnected) {
        debugPrint('❌ SignalR: Try Conneccting.');
        await connect();
      }
      debugPrint('📋 SignalR: MessageInfo:');
      debugPrint('   - desc: ${command['description']}');
      debugPrint('   - conversationId: ${command['conversationId']}');
      debugPrint('   - fromUserId: ${command['fromUserId']}');
      debugPrint('   - toUserId: ${command['toUserId']}');
      debugPrint('   - fromPetId: ${command['fromPetId']}');
      debugPrint('   - toPetId: ${command['toPetId']}');

      const methodNames = [
        'SenMessageToUser',
        'SendMessageToUser',
        'SendMessage',
        'sendMessage',
      ];

      bool success = false;
      String? lastError;

      for (final methodName in methodNames) {
        try {
          debugPrint('🔄 SignalR: Trying to invoke: $methodName');
          await _hubConnection!.invoke(methodName, args: [command]);
          debugPrint('✅ SignalR: Sent via: $methodName');
          success = true;
          break;
        } catch (e) {
          lastError = e.toString();
          debugPrint('⚠️ SignalR: Failed $methodName - $e');
          continue;
        }
      }

      if (!success) {
        debugPrint('❌ SignalR: All attempts failed. Last error: $lastError');
        throw Exception('Failed to send message via all methods.');
      }
    } catch (e) {
      debugPrint('❌ SignalR: Failed to send message  $e');
      rethrow;
    }
  }

  void onMessageReceived(String methodName, Function(List<Object?>?) callback) {
    if (_hubConnection == null) {
      debugPrint('❌ SignalR: No connection to listen on.');
      return;
    }

    debugPrint('👂 SignalR: Starting to listen for messages on: $methodName');
    _hubConnection!.on(methodName, (arguments) {
      debugPrint('📨 SignalR: Incoming message from server!');
      debugPrint('📦 SignalR: Data: $arguments');
      callback(arguments);
    });
  }

  Future<void> disconnect() async {
    try {
      if (_hubConnection == null) {
        debugPrint('⚠️ SignalR: No connection to disconnect.');
        return;
      }

      debugPrint('🔴 SignalR: Disconnecting...');
      await _hubConnection!.stop();
      _hubConnection = null;
      debugPrint('✅ SignalR: Disconnected successfully');
    } catch (e) {
      debugPrint('❌ SignalR: Error while disconnecting - $e');
      _hubConnection = null;
    }
  }

  String? get connectionId => _hubConnection?.connectionId;

  void checkConnection() {
    debugPrint('📊 SignalR:Current Connection Status:');
    debugPrint('   - Connected: $isConnected');
    debugPrint('   - State: ${connectionState.toString()}');
    debugPrint('   - Connection ID: ${connectionId ?? 'Unavailable'}');
  }
}
