import 'package:flutter/material.dart';
import 'package:squeak/core/service/signalr/signalr_conversation_services.dart';

class SignalRConnectionIndicator extends StatefulWidget {
  const SignalRConnectionIndicator({super.key});

  @override
  State<SignalRConnectionIndicator> createState() =>
      _SignalRConnectionIndicatorState();
}

class _SignalRConnectionIndicatorState
    extends State<SignalRConnectionIndicator> {
  final SignalRConversationHubService _signalRService =
      SignalRConversationHubService();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _startConnectionCheck();
  }

  void _checkConnection() {
    if (mounted) {
      setState(() {
        // Check Conversation Hub connection
        _isConnected = _signalRService.isConnected;
      });
    }
  }

  void _startConnectionCheck() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      _checkConnection();
      return mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isConnected ? Colors.green : Colors.orange,
        boxShadow: [
          BoxShadow(
            color: (_isConnected ? Colors.green : Colors.orange).withOpacity(
              0.5,
            ),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
