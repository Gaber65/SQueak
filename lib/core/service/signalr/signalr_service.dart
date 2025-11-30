import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

/// ===============================================================
///  GLOBAL EVENT STREAM
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
///  SIGNALR SERVICE
/// ===============================================================
class SignalRService {
  // ---------------------------------------------------------------
  // URLs
  // ---------------------------------------------------------------
  static const String _conversationHubUrl =
      'https://squeakapi.veticareapp.com:8001/conversationhub';
  static const String _generalHubUrl =
      'https://squeakapi.veticareapp.com:8001/generalhub';

  // Hub instances
  HubConnection? _conversationHub;
  HubConnection? _generalHub;

  // Singleton
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  // ===============================================================
  // CONNECTION STATUS
  // ===============================================================
  bool get isConversationHubConnected =>
      _conversationHub?.state == HubConnectionState.Connected;

  bool get isGeneralHubConnected =>
      _generalHub?.state == HubConnectionState.Connected;

  String? get conversationHubConnectionId => _conversationHub?.connectionId;
  String? get generalHubConnectionId => _generalHub?.connectionId;

  // ===============================================================
  // CONNECT TO CONVERSATION HUB
  // ===============================================================
  Future<void> connectToConversationHub() async {
    try {
      final token = CacheHelper.getData('token');
      if (token == null) {
        debugPrint("❌ No token found for ConversationHub");
        return;
      }

      if (_conversationHub != null && isConversationHubConnected) {
        debugPrint("✔️ ConversationHub already connected");
        return;
      }

      _conversationHub = HubConnectionBuilder()
          .withUrl(
        _conversationHubUrl,
        options: HttpConnectionOptions(
          accessTokenFactory: () async => token.toString(),
          transport: HttpTransportType.WebSockets,
        ),
      )
          .withAutomaticReconnect()
          .build();

      debugPrint("🚀 Connecting to ConversationHub…");

      _registerConversationEvents();

      await _conversationHub!.start();
      debugPrint("✅ ConversationHub Connected");
      debugPrint("🆔 ID: ${_conversationHub!.connectionId}");
    } catch (e) {
      debugPrint("❌ ConversationHub Error → $e");
    }
  }

  // ===============================================================
  // CONNECT TO GENERAL HUB
  // ===============================================================
  Future<void> connectToGeneralHub() async {
    try {
      final token = CacheHelper.getData('token');
      if (token == null) {
        debugPrint("❌ No token found for GeneralHub");
        return;
      }

      if (_generalHub != null && isGeneralHubConnected) {
        debugPrint("✔️ GeneralHub already connected");
        return;
      }

      _generalHub = HubConnectionBuilder()
          .withUrl(
        _generalHubUrl,
        options: HttpConnectionOptions(
          accessTokenFactory: () async => token.toString(),
          transport: HttpTransportType.WebSockets,
        ),
      )
          .withAutomaticReconnect()
          .build();

      debugPrint("🚀 Connecting to GeneralHub…");

      _registerGeneralEvents();

      await _generalHub!.start();
      debugPrint("✅ GeneralHub Connected");
      debugPrint("🆔 ID: ${_generalHub!.connectionId}");
    } catch (e) {
      debugPrint("❌ GeneralHub Error → $e");
    }
  }

  // ===============================================================
  // REGISTER EVENTS
  // ===============================================================
  void _registerConversationEvents() {
    if (_conversationHub == null) return;
    _registerEvents(_conversationHub!, "ConversationHub", [
      "ReceiveMessageFromUser",
      "NewMessage",
      "SetTyping",
    ]);

    _conversationHub!.onclose(({error}) {
      debugPrint("🔴 ConversationHub Disconnected → $error");
    });
  }

  void _registerGeneralEvents() {
    if (_generalHub == null) return;
    _registerEvents(_generalHub!, "GeneralHub", [
      "FriendIsTyping",
      "ChatListUpdated",
    ]);

    _generalHub!.onclose(({error}) {
      debugPrint("🔴 GeneralHub Disconnected → $error");
    });
  }

  void _registerEvents(HubConnection hub, String hubName, List<String> methods) {
    for (var method in methods) {
      hub.on(method, (arguments) {
        debugPrint("📥 [$hubName] $method → $arguments");
        signalEventStream.add(SignalEvent(hubName, method, arguments));
      });
    }
  }

  // ===============================================================
  // SEND MESSAGE
  // ===============================================================
  Future<void> sendMessage(Map<String, dynamic> command) async {
    if (!isConversationHubConnected) await connectToConversationHub();

    try {
      await _conversationHub!.invoke("SendMessageToUser", args: [command]);
      debugPrint("📤 Message Sent → $command");
    } catch (e) {
      debugPrint("❌ Error sending message: $e");
    }
  }

  // ===============================================================
  // TYPING INDICATOR (Conversation)
  // ===============================================================
  Future<void> setTyping({
    required String conversationId,
    required String petId,
    required bool isTyping,
  }) async {
    if (!isConversationHubConnected) return;

    try {
      await _conversationHub!.invoke(
        "SetTyping",
        args: [conversationId, petId, isTyping],
      );
      debugPrint("⌨️ SetTyping Sent → $conversationId | $petId | $isTyping");
    } catch (e) {
      debugPrint("❌ Error SetTyping: $e");
    }
  }

  // ===============================================================
  // TYPING INDICATOR (General)
  // ===============================================================
  Future<void> setTypingIndicator({
    required String toPetId,
    required bool isTyping,
  }) async {
    if (!isGeneralHubConnected) return;

    try {
      await _generalHub!.invoke("SetTypingIndicator", args: [toPetId, isTyping]);
      debugPrint("📡 TypingIndicator Sent → $toPetId | $isTyping");
    } catch (e) {
      debugPrint("❌ Error TypingIndicator: $e");
    }
  }

  // ===============================================================
  // onConversationMessageReceived
  // ===============================================================
  void onConversationMessageReceived(
      String methodName,
      Function(List<Object?>?) callback,
      ) {
    if (_conversationHub == null) {
      debugPrint("❌ ConversationHub is null");
      return;
    }

    _conversationHub!.on(methodName, (arguments) {
      debugPrint("📨 ConversationHub → $methodName : $arguments");
      callback(arguments);
    });
  }

  // ===============================================================
  // markMessagesAsRead
  // ===============================================================
  Future<void> markMessagesAsRead(String conversationId, String petId) async {
    if (!isConversationHubConnected) return;

    try {
      await _conversationHub!.invoke(
        'MarkAllUnreadedMessagesInConversationAsRead',
        args: [conversationId, petId],
      );
      debugPrint("📖 Messages marked as read → $conversationId");
    } catch (e) {
      debugPrint("❌ markMessagesAsRead Error: $e");
    }
  }

  // ===============================================================
  // getUnreadMessageCounts
  // ===============================================================
  Future<Map<String, int>?> getUnreadMessageCounts(String petId) async {
    if (!isGeneralHubConnected) return null;

    try {
      final result = await _generalHub!.invoke('GetUnreadMessageCounts', args: [petId]);
      if (result is Map) {
        return result.map((key, value) => MapEntry(key.toString(), value as int));
      }
    } catch (e) {
      debugPrint("❌ getUnreadMessageCounts Error: $e");
    }
    return null;
  }

  // ===============================================================
  // DISCONNECT METHODS
  // ===============================================================
  Future<void> disconnectFromConversationHub() async {
    if (_conversationHub == null) return;

    try {
      await _conversationHub!.stop();
      debugPrint("🔴 ConversationHub Disconnected");
    } catch (e) {
      debugPrint("❌ disconnectFromConversationHub Error: $e");
    }
    _conversationHub = null;
  }

  Future<void> disconnectFromGeneralHub() async {
    if (_generalHub == null) return;

    try {
      await _generalHub!.stop();
      debugPrint("🔴 GeneralHub Disconnected");
    } catch (e) {
      debugPrint("❌ disconnectFromGeneralHub Error: $e");
    }
    _generalHub = null;
  }

  Future<void> disconnectAll() async {
    await disconnectFromConversationHub();
    await disconnectFromGeneralHub();
  }
}
