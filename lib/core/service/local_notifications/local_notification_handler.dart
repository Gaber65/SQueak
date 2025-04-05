import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_navigation.dart';

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  print('Received notification with app Terminated: ${details.payload}');
  if (details.payload != null) {
    handleNavigation(details.payload!);
  }
}