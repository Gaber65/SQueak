import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'notification_navigation.dart';
import 'notification_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String? initialNotificationPayload;

Future<void> initNotifications() async {
  tz.initializeTimeZones();

  const initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      print('Notification clicked with payload: ${response.payload}');
      if (response.payload != null) {
        handleNavigation(response.payload!);
      }
    },
  );

  final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (details?.didNotificationLaunchApp ?? false) {
    initialNotificationPayload = details?.notificationResponse?.payload;
  }

  await NotificationServiceReminder.init();
}
