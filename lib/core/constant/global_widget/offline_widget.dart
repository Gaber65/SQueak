import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../../generated/l10n.dart';

class OfflineWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const OfflineWidget({
    super.key,
    required this.onlineChild,
    required this.offlineChild,
  });

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder:(context, value, child) {
        final bool isConnected = value != ConnectivityResult.none;
        return isConnected ? onlineChild : offlineChild;
      },
      child: Center(child: CircularProgressIndicator()),
    );
  }

  static Future<void> showOfflineWidget(context) {
    return QuickAlert.show(
      context: context,
      width: 400,
      type: QuickAlertType.warning,
      title: S.of(context).offlineMessagesTitle,
      text: S.of(context).offlineMessagesContent,
    );
  }
}
