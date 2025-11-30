import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

class SignalRService {
  // Hub URLs
  static const String _conversationHubUrl =
      'https://squeakapi.veticareapp.com:8001/conversationhub';
  static const String _generalHubUrl =
      'https://squeakapi.veticareapp.com:8001/generalhub';

  // Two separate hub connections
  HubConnection? _conversationHub; 
  HubConnection? _generalHub; 

  // Connection states
  HubConnectionState get conversationHubState =>
      _conversationHub?.state ?? HubConnectionState.Disconnected;
  
  HubConnectionState get generalHubState =>
      _generalHub?.state ?? HubConnectionState.Disconnected;

  bool get isConversationHubConnected => conversationHubState == HubConnectionState.Connected;
  bool get isGeneralHubConnected => generalHubState == HubConnectionState.Connected;

  // Singleton pattern
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  // CONVERSATION HUB - For individual chat messages
  // Connect when user opens a specific chat conversation
  Future<void> connectToConversationHub() async {
    try {
      debugPrint('📞 Starting Conversation Hub connection...');
      final token = CacheHelper.getData('token');
      if (token == null || token.toString().isEmpty) {
        debugPrint('❌ No token found - connection cancelled.');
        return;
      }

      // If already connected, skip
      if (_conversationHub != null && isConversationHubConnected) {
        debugPrint('✅ Conversation Hub already connected');
        return;
      }

      // Disconnect if exists but not connected
      if (_conversationHub != null && !isConversationHubConnected) {
        debugPrint('🔄 Reconnecting Conversation Hub');
        await disconnectFromConversationHub();
      }

      debugPrint('🔧 Creating Conversation Hub instance');
      _conversationHub = HubConnectionBuilder()
          .withUrl(
            _conversationHubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token.toString(),
              requestTimeout: 30000,
              skipNegotiation: false,
              transport: HttpTransportType.WebSockets,
            ),
          )
          .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000, 30000])
          .build();

      _registerConversationHubEvents();

      debugPrint('🚀 Connecting to Conversation Hub...');
      await _conversationHub!.start();
      debugPrint('✅ Conversation Hub Connected!');
      debugPrint('🆔 Connection ID: ${_conversationHub!.connectionId}');
    } catch (e) {
      debugPrint('❌ Conversation Hub connection failed: $e');
      rethrow;
    }
  }

  // GENERAL HUB - For chat list updates and notifications
  // Connect when user opens chat list screen
  Future<void> connectToGeneralHub() async {
    try {
      debugPrint('📋 Starting General Hub connection...');
      final token = CacheHelper.getData('token');
      if (token == null || token.toString().isEmpty) {
        debugPrint('❌ No token found - connection cancelled.');
        return;
      }

      // If already connected, skip
      if (_generalHub != null && isGeneralHubConnected) {
        debugPrint('✅ General Hub already connected');
        return;
      }

      // Disconnect if exists but not connected
      if (_generalHub != null && !isGeneralHubConnected) {
        debugPrint('🔄 Reconnecting General Hub');
        await disconnectFromGeneralHub();
      }

      debugPrint('🔧 Creating General Hub instance');
      _generalHub = HubConnectionBuilder()
          .withUrl(
            _generalHubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token.toString(),
              requestTimeout: 30000,
              skipNegotiation: false,
              transport: HttpTransportType.WebSockets,
            ),
          )
          .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000, 30000])
          .build();

      _registerGeneralHubEvents();

      debugPrint('🚀 Connecting to General Hub...');
      await _generalHub!.start();
      debugPrint('✅ General Hub Connected!');
      debugPrint('🆔 Connection ID: ${_generalHub!.connectionId}');
    } catch (e) {
      debugPrint('❌ General Hub connection failed: $e');
      rethrow;
    }
  }

  // Register events for Conversation Hub
  void _registerConversationHubEvents() {
    if (_conversationHub == null) return;
    
    _conversationHub!.onclose(({error}) {
      debugPrint('🔴 Conversation Hub: Disconnected');
      if (error != null) debugPrint('❌ Error: $error');
    });

    _conversationHub!.onreconnecting(({error}) {
      debugPrint('🔄 Conversation Hub: Reconnecting...');
      if (error != null) debugPrint('⚠️ Error: $error');
    });

    _conversationHub!.onreconnected(({connectionId}) {
      debugPrint('✅ Conversation Hub: Reconnected!');
      debugPrint('🆔 Connection ID: $connectionId');
    });
  }

  // Register events for General Hub
  void _registerGeneralHubEvents() {
    if (_generalHub == null) return;
    
    _generalHub!.onclose(({error}) {
      debugPrint('🔴 General Hub: Disconnected');
      if (error != null) debugPrint('❌ Error: $error');
    });

    _generalHub!.onreconnecting(({error}) {
      debugPrint('🔄 General Hub: Reconnecting...');
      if (error != null) debugPrint('⚠️ Error: $error');
    });

    _generalHub!.onreconnected(({connectionId}) {
      debugPrint('✅ General Hub: Reconnected!');
      debugPrint('🆔 Connection ID: $connectionId');
    });
  }

  // Send message through Conversation Hub (used in chat screen)
  Future<void> sendMessageToUser(Map<String, dynamic> command) async {
    try {
      debugPrint('📤 Sending message through Conversation Hub...');
      
      // Ensure conversation hub is connected
      if (!isConversationHubConnected) {
        debugPrint('⚠️ Conversation Hub not connected, connecting...');
        await connectToConversationHub();
      }

      debugPrint('📋 Message Info:');
      debugPrint('   - conversationId: ${command['conversationId']}');
      debugPrint('   - fromUserId: ${command['fromUserId']}');
      debugPrint('   - toUserId: ${command['toUserId']}');

      // Try different method names (server API might vary)
      const methodNames = [
        'SendMessageToUser',
        'SenMessageToUser',
        'SendMessage',
        'sendMessage',
      ];

      bool success = false;
      String? lastError;

      for (final methodName in methodNames) {
        try {
          debugPrint('🔄 Trying method: $methodName');
          await _conversationHub!.invoke(methodName, args: [command]);
          debugPrint('✅ Message sent via: $methodName');
          success = true;
          break;
        } catch (e) {
          lastError = e.toString();
          debugPrint('⚠️ Failed with $methodName: $e');
          continue;
        }
      }

      if (!success) {
        debugPrint('❌ All send attempts failed. Last error: $lastError');
        throw Exception('Failed to send message');
      }
    } catch (e) {
      debugPrint('❌ Error sending message: $e');
      rethrow;
    }
  }

  // Listen for messages on Conversation Hub (for individual chat messages)
  void onConversationMessageReceived(
    String methodName,
    Function(List<Object?>?) callback,
  ) {
    if (_conversationHub == null) {
      debugPrint('❌ Conversation Hub not initialized');
      return;
    }

    debugPrint('👂 Listening on Conversation Hub: $methodName');
    _conversationHub!.on(methodName, (arguments) {
      debugPrint('📨 Conversation Hub: Message received!');
      debugPrint('📦 Data: $arguments');
      callback(arguments);
    });
  }

  // Listen for updates on General Hub (for chat list updates)
  void onGeneralMessageReceived(
    String methodName,
    Function(List<Object?>?) callback,
  ) {
    if (_generalHub == null) {
      debugPrint('❌ General Hub not initialized');
      return;
    }

    debugPrint('👂 Listening on General Hub: $methodName');
    _generalHub!.on(methodName, (arguments) {
      debugPrint('📨 General Hub: Update received!');
      debugPrint('📦 Data: $arguments');
      callback(arguments);
    });
  }

  // Disconnect from Conversation Hub (when leaving a chat)
  Future<void> disconnectFromConversationHub() async {
    try {
      if (_conversationHub == null) {
        debugPrint('⚠️ Conversation Hub already disconnected');
        return;
      }

      debugPrint('🔴 Disconnecting Conversation Hub...');
      await _conversationHub!.stop();
      _conversationHub = null;
      debugPrint('✅ Conversation Hub disconnected');
    } catch (e) {
      debugPrint('❌ Error disconnecting Conversation Hub: $e');
      _conversationHub = null;
    }
  }

  // Disconnect from General Hub (when leaving chat list screen)
  Future<void> disconnectFromGeneralHub() async {
    try {
      if (_generalHub == null) {
        debugPrint('⚠️ General Hub already disconnected');
        return;
      }

      debugPrint('🔴 Disconnecting General Hub...');
      await _generalHub!.stop();
      _generalHub = null;
      debugPrint('✅ General Hub disconnected');
    } catch (e) {
      debugPrint('❌ Error disconnecting General Hub: $e');
      _generalHub = null;
    }
  }

  // Disconnect from both hubs (for complete cleanup)
  Future<void> disconnectAll() async {
    await Future.wait([
      disconnectFromConversationHub(),
      disconnectFromGeneralHub(),
    ]);
    debugPrint('✅ All hubs disconnected');
  }

  // Get connection IDs
  String? get conversationHubConnectionId => _conversationHub?.connectionId;
  String? get generalHubConnectionId => _generalHub?.connectionId;

  // Check connection status for both hubs
  void checkConnection() {
    debugPrint('📊 SignalR Connection Status:');
    debugPrint('--- Conversation Hub (for chat messages) ---');
    debugPrint('   - Connected: $isConversationHubConnected');
    debugPrint('   - State: ${conversationHubState.toString()}');
    debugPrint('   - Connection ID: ${conversationHubConnectionId ?? 'N/A'}');
    debugPrint('--- General Hub (for chat list) ---');
    debugPrint('   - Connected: $isGeneralHubConnected');
    debugPrint('   - State: ${generalHubState.toString()}');
    debugPrint('   - Connection ID: ${generalHubConnectionId ?? 'N/A'}');
  }
}
