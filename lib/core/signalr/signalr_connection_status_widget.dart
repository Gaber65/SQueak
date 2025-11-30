import 'package:flutter/material.dart';
import 'package:squeak/core/service/signalr/signalr_service.dart';

// Shows a banner when Conversation Hub (for chat messages) is disconnected
class SignalRConnectionStatusWidget extends StatefulWidget {
  const SignalRConnectionStatusWidget({super.key});

  @override
  State<SignalRConnectionStatusWidget> createState() =>
      _SignalRConnectionStatusWidgetState();
}

class _SignalRConnectionStatusWidgetState
    extends State<SignalRConnectionStatusWidget> {
  final SignalRService _signalRService = SignalRService();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    Future.delayed(Duration.zero, () {
      _startConnectionCheck();
    });
  }

  void _checkConnection() {
    if (mounted) {
      setState(() {
        // Check Conversation Hub connection (for chat messages)
        _isConnected = _signalRService.isConversationHubConnected;
      });
    }
  }

  void _startConnectionCheck() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 10));
      _checkConnection();
      return mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (_isConnected) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(isDark ? 0.3 : 0.15),
            Colors.orange.withOpacity(isDark ? 0.2 : 0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.signal_wifi_off_rounded,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'جارٍ إعادة الاتصال...',
              style: TextStyle(
                color: isDark ? Colors.orange.shade200 : Colors.orange.shade800,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                isDark ? Colors.orange.shade200 : Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Small indicator showing Conversation Hub connection status
class SignalRConnectionIndicator extends StatefulWidget {
  const SignalRConnectionIndicator({super.key});

  @override
  State<SignalRConnectionIndicator> createState() =>
      _SignalRConnectionIndicatorState();
}

class _SignalRConnectionIndicatorState
    extends State<SignalRConnectionIndicator> {
  final SignalRService _signalRService = SignalRService();
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
        _isConnected = _signalRService.isConversationHubConnected;
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
            color: (_isConnected ? Colors.green : Colors.orange).withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
