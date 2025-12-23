import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'local_notification_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String? initialNotificationPayload;

void showUploadNotification(int progress, String fileName) async {
  flutterLocalNotificationsPlugin.show(
    1,
    "Uploading $fileName",
    "$progress% completed",
    NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
      ),
      android: AndroidNotificationDetails(
        'upload_channel',
        'Uploads',
        channelDescription: 'Show upload progress',
        ongoing: true,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: 100,
        progress: progress,
      ),
    ),
  );
}
class NotificationInitializer {
  /// Initialize the complete notification system
  static Future<void> initialize() async {

    // Initialize timezone data
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    // Request permissions
    await _requestPermissions();

    // Android initialization settings
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosSettings,
    );

    // Initialize the plugin with notification response handler
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          LocalNotificationHandler.handleNotificationResponse,
      onDidReceiveNotificationResponse:
          LocalNotificationHandler.handleNotificationResponse,
    );

    // Check if app was launched from notification
    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      initialNotificationPayload = details?.notificationResponse?.payload;
    }

  }

  /// Request notification permissions (Android 13+)
  static Future<void> _requestPermissions() async {
    try {
      if (await Permission.notification.isDenied) {

        await Permission.notification.request();
      } else {

      }
    } catch (e, stackTrace) {
      // You can log or handle the error here
      debugPrint('Error while requesting notification permission: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// Get initial notification payload (if app was launched from notification)
  static String? getInitialNotificationPayload() {
    return initialNotificationPayload;
  }

  /// Generate unique notification ID
  static int generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
