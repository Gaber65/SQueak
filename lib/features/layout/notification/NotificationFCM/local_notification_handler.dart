// local_notification_handler.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_initializer.dart';
import 'notification_navigation.dart';

class LocalNotificationHandler {
  /// Handle notification responses (clicks and actions)
  static Future<void> handleNotificationResponse(
    NotificationResponse response,
  ) async {
    // print('Notification response received: ${response.payload}');

    if (response.payload == null) return;

    // Handle action buttons (snooze, ignore)
    if (response.actionId == 'snooze_action') {
      await _handleSnooze(response.payload);
      return;
    } else if (response.actionId == 'ignore_action') {
      await _handleIgnore(response.payload);
      return;
    }

    // Handle navigation for regular notification clicks
    NotificationNavigation.handleNavigation(response.payload!);
  }

  /// Handle snooze action - reschedule notification for 5 minutes later
  static Future<void> _handleSnooze(String? payload) async {
    if (payload == null) return;

    try {
      final parts = payload.split('|');
      if (parts.length == 3) {
        final id = int.parse(parts[0].split('_')[1]);
        final originalTitle = parts[1];
        final originalBody = parts[2];

        final now = tz.TZDateTime.now(tz.local);
        final snoozeTime = now.add(Duration(minutes: 5));

        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
              'reminder_channel',
              'Reminders',
              importance: Importance.high,
              priority: Priority.high,
              sound: RawResourceAndroidNotificationSound('notification'),
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction('snooze_action', 'Snooze'),
                AndroidNotificationAction('ignore_action', 'Ignore'),
              ],
            );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          originalTitle,
          originalBody,
          snoozeTime,
          const NotificationDetails(android: androidDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'reminder_$id|$originalTitle|$originalBody',
        );

        // print("Notification $id snoozed until $snoozeTime");
      }
    } catch (e) {
      // print('Error handling snooze: $e');
    }
  }

  /// Handle ignore action - cancel the notification
  static Future<void> _handleIgnore(String? payload) async {
    if (payload == null) return;

    try {
      final id = int.parse(payload.split('_')[1]);
      await flutterLocalNotificationsPlugin.cancel(id);
      // print("Notification $id ignored and cancelled");
    } catch (e) {
      // print('Error handling ignore: $e');
    }
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    // print("Notification with ID: $id has been cancelled.");
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    // print("All scheduled notifications have been cancelled.");
  }
}
