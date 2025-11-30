import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

/// ===============================================================
/// GLOBAL EVENT STREAM
/// ===============================================================
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

/// ===============================================================
/// SIGNALR SERVICE
/// ===============================================================
class SignalRService {
  static const String _conversationHubUrl =
      'https://squeakapi.veticareapp.com:8001/conversationhub';
  static const String _generalHubUrl =
      'https://squeakapi.veticareapp.com:8001/generalhub';

  HubConnection? _conversationHub;
  HubConnection? _generalHub;

  final StreamController<bool> _generalHubConnectionController =
  StreamController<bool>.broadcast();
  final StreamController<bool> _conversationHubConnectionController =
  StreamController<bool>.broadcast();

  Stream<bool> get generalHubConnectionStream =>
      _generalHubConnectionController.stream;
  Stream<bool> get conversationHubConnectionStream =>
      _conversationHubConnectionController.stream;

  // Update connection methods to use the streams
  Future<void> connectToGeneralHub() async {
    try {
      _generalHub = await _connectHub(_generalHubUrl, "GeneralHub");
      _registerGeneralEvents();
      _generalHubConnectionController.add(true);
      debugPrint('✅ GeneralHub connected successfully');
    } catch (e) {
      _generalHubConnectionController.add(false);
      rethrow;
    }
  }

  Future<void> connectToConversationHub() async {
    try {
      _conversationHub = await _connectHub(_conversationHubUrl, "ConversationHub");
      _registerConversationEvents();
      _conversationHubConnectionController.add(true);
      debugPrint('✅ ConversationHub connected successfully');
    } catch (e) {
      _conversationHubConnectionController.add(false);
      rethrow;
    }
  }

  Future<void> disconnectFromGeneralHub() async {
    if (_generalHub == null) return;
    await _generalHub!.stop();
    _generalHubConnectionController.add(false);
    debugPrint("🔴 GeneralHub Disconnected");
    _generalHub = null;
  }

  Future<void> disconnectFromConversationHub() async {
    if (_conversationHub == null) return;
    await _conversationHub!.stop();
    _conversationHubConnectionController.add(false);
    debugPrint("🔴 ConversationHub Disconnected");
    _conversationHub = null;
  }


  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  bool get isConversationHubConnected =>
      _conversationHub?.state == HubConnectionState.Connected;

  bool get isGeneralHubConnected =>
      _generalHub?.state == HubConnectionState.Connected;

  String? get conversationHubConnectionId => _conversationHub?.connectionId;
  String? get generalHubConnectionId => _generalHub?.connectionId;

  /// ===============================================================
  /// GENERIC CONNECT METHOD
  /// ===============================================================
  Future<HubConnection?> _connectHub(String hubUrl, String hubName) async {
    final token = CacheHelper.getData('token');
    if (token == null) {
      debugPrint("❌ No token found for $hubName");
      return null;
    }

    HubConnection? hub =
        (hubName == "ConversationHub") ? _conversationHub : _generalHub;

    if (hub != null && hub.state == HubConnectionState.Connected) {
      debugPrint("✔️ $hubName already connected");
      return hub;
    }

    hub =
        HubConnectionBuilder()
            .withUrl(
              hubUrl,
              options: HttpConnectionOptions(
                accessTokenFactory: () async => token.toString(),
                transport: HttpTransportType.WebSockets,
              ),
            )
            .withAutomaticReconnect()
            .build();

    hub.onclose(({error}) {
      debugPrint("🔴 $hubName Disconnected → $error");
    });

    try {
      await hub.start();
      debugPrint("✅ $hubName Connected");
      debugPrint("🆔 ID: ${hub.connectionId}");
      return hub;
    } catch (e) {
      debugPrint("❌ $hubName Error → $e");
      return null;
    }
  }





  /// ===============================================================
  /// GENERIC EVENT REGISTRATION
  /// ===============================================================
  void _registerEvents(
    HubConnection hub,
    String hubName,
    List<String> methods,
  ) {
    for (var method in methods) {
      hub.on(method, (arguments) {
        debugPrint("📥 [$hubName] $method → $arguments");
        signalEventStream.add(SignalEvent(hubName, method, arguments));
      });
    }
  }

  void _registerConversationEvents() {
    if (_conversationHub == null) return;
    _registerEvents(_conversationHub!, "ConversationHub", [
      "ReceiveMessage",
      "NewMessage",
      "SetTyping",
    ]);
  }

  void _registerGeneralEvents() {
    if (_generalHub == null) return;
    _registerEvents(_generalHub!, "GeneralHub", [
      "FriendIsTyping",
      "ChatListUpdated",
    ]);
  }

  /// ===============================================================
  /// GENERIC INVOKE METHOD
  /// ===============================================================
  Future<T?> invokeHub<T>(
    HubConnection hub,
    String hubName,
    String methodName, {
    List<Object?>? args,
  }) async {
    if (hub.state != HubConnectionState.Connected) {
      debugPrint("⚠️ $hubName is not connected, attempting to reconnect…");
      await _connectHub(
        hubName == "ConversationHub" ? _conversationHubUrl : _generalHubUrl,
        hubName,
      );
    }

    try {
      final result = await hub.invoke(methodName, args: args?.cast<Object>());
      debugPrint("📤 [$hubName] $methodName → ${args ?? []}");
      return result as T?;
    } catch (e) {
      debugPrint("❌ [$hubName] $methodName Error → $e");
      return null;
    }
  }

  /// ===============================================================
  /// SEND MESSAGE
  /// ===============================================================
  Future<void> sendMessage(Map<String, dynamic> command) async {
    if (!isConversationHubConnected) await connectToConversationHub();
    if (_conversationHub != null) {
      await invokeHub<void>(
        _conversationHub!,
        "ConversationHub",
        "SendMessageToUser",
        args: [command],
      );
    }
  }

  /// ===============================================================
  /// TYPING INDICATORS
  /// ===============================================================
  Future<void> setTyping({
    required String conversationId,
    required String petId,
    required bool isTyping,
  }) async {
    if (!isConversationHubConnected) await connectToConversationHub();
    if (_conversationHub != null) {
      await invokeHub<void>(
        _conversationHub!,
        "ConversationHub",
        "SetTyping",
        args: [conversationId, petId, isTyping],
      );
    }
  }

  Future<void> setTypingIndicator({
    required String toPetId,
    required bool isTyping,
  }) async {
    if (!isGeneralHubConnected) await connectToGeneralHub();
    if (_generalHub != null) {
      await invokeHub<void>(
        _generalHub!,
        "GeneralHub",
        "SetTypingIndicator",
        args: [toPetId, isTyping],
      );
    }
  }

  /// ===============================================================
  /// CONVERSATION MESSAGE CALLBACK
  /// ===============================================================
  void onConversationMessageReceived(
    String methodName,
    Function(List<Object?>?) callback,
  ) {
    if (_conversationHub == null) return;
    _conversationHub!.on(methodName, (args) {
      callback(args);
    });
  }

  /// ===============================================================
  /// MARK MESSAGES AS READ
  /// ===============================================================
  Future<void> markMessagesAsRead(String conversationId, String petId) async {
    if (!isConversationHubConnected) await connectToConversationHub();
    if (_conversationHub != null) {
      await invokeHub<void>(
        _conversationHub!,
        "ConversationHub",
        "MarkAllUnreadedMessagesInConversationAsRead",
        args: [conversationId, petId],
      );
    }
  }

  /// ===============================================================
  /// GET UNREAD MESSAGE COUNTS
  /// ===============================================================
  Future<Map<String, int>?> getUnreadMessageCounts(String petId) async {
    if (!isGeneralHubConnected) await connectToGeneralHub();
    final result = await invokeHub<Map<dynamic, dynamic>>(
      _generalHub!,
      "GeneralHub",
      "GetUnreadMessageCounts",
      args: [petId],
    );
    if (result == null) return null;
    return result.map((key, value) => MapEntry(key.toString(), value as int));
  }

  /// ===============================================================
  /// DISCONNECT METHODS
  /// ===============================================================


  Future<void> disconnectAll() async {
    await disconnectFromConversationHub();
    await disconnectFromGeneralHub();
  }
}
