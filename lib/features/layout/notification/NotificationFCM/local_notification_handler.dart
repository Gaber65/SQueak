import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../core/service/main_service/presentation/screens/navigator_key.dart';
import '../../../../core/utils/enums/notification_type_enums.dart';
import '../NotificationAPI/domain/entities/notification_entities.dart';
import '../NotificationAPI/presentation/widget/navigate_based_on_notification.dart';
import 'notification_initializer.dart';

class LocalNotificationHandler {
  /// Handle notification responses (clicks and actions)
  @pragma('vm:entry-point')
  static Future<void> handleNotificationResponse(
    NotificationResponse response,
  ) async {

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
    final entity = payloadToNotificationEntity(response.payload!);
    return navigateBasedOnNotification(entity, navigatorKey.currentContext!);
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

      }
    } catch (_) {}
  }

  /// Handle ignore action - cancel the notification
  static Future<void> _handleIgnore(String? payload) async {
    if (payload == null) return;

    try {
      final id = int.parse(payload.split('_')[1]);
      await flutterLocalNotificationsPlugin.cancel(id);

    } catch (_) {}
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);

  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();

  }
}

NotificationEntities payloadToNotificationEntity(String payload) {
  final jsonData = jsonDecode(payload);

  return NotificationEntities(
    message: jsonData['message'] ?? '',
    eventType: NotificationType.values.firstWhere(
      (e) =>
          e.toString().split('.').last ==
          (jsonData['eventType'] ?? '').toString(),
      orElse: () => NotificationType.NewPostAdded,
    ),
    eventTypeId: jsonData['eventTypeId'] ?? '',
    title: jsonData['title'] ?? '',
    logo: jsonData['logo'] ?? '',
    notificationEvents: [],
    id: jsonData['id'] ?? '',
    createdAt: jsonData['createdAt'] ?? '',
    isActive: jsonData['isActive'] ?? true,
    isDeleted: jsonData['isDeleted'] ?? false,
    arMessage: jsonData['arMessage'] ?? '',
    arTitle: jsonData['eventType'] ?? '',
  );
}
