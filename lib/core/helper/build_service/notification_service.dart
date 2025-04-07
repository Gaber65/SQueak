import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ✅ Initialize Notification Service
  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    await _requestPermissions();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("Notification Response: ${response.payload}");
        print("Action ID: ${response.actionId}");

        if (response.actionId == 'snooze_action') {
          await _handleSnooze(response.payload);
        } else if (response.actionId == 'ignore_action') {
          await _handleIgnore(response.payload);
        }
      },
    );
  }

  static Future<void> _handleSnooze(String? payload) async {
    if (payload != null) {
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

        await _notificationsPlugin.zonedSchedule(
          id,
          originalTitle,  // Use original title
          originalBody,   // Use original body
          snoozeTime,
          const NotificationDetails(android: androidDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'notification_$id|$originalTitle|$originalBody', // Pass payload forward
        );
        print("Notification $id snoozed until $snoozeTime");
      }
    }
  }
  // Handle Ignore (Cancel the notification)
  static Future<void> _handleIgnore(String? payload) async {
    if (payload != null) {
      final id = int.parse(payload.split('_')[1]);
      await cancelNotification(id);
      print("Notification $id ignored and cancelled");
    }
  }

  // ✅ Request Notification Permission (For Android 13+)
  static Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // ✅ Schedule Notification with Different Frequencies
  // ✅ Schedule Notification with Different Frequencies
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime startDate,
    required TimeOfDay startTime,
    required String frequency, // "once", "daily", "weekly", "monthly", "yearly"
  }) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.getLocation('Africa/Cairo'),
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );
    print("elkerm*********");
    print("startDate.year, : ${startDate.year}");
    print("startDate.month, : ${startDate.month}");
    print("startDate.day, : ${startDate.day}");
    print("startDate.hour, : ${startDate.hour}");
    print("startDate.minute, : ${startDate.minute}");

    // ✅ Ensure the scheduled date is in the future
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      switch (frequency) {
        case "Daily":
          print("Daily Case");
          scheduledDate = scheduledDate.add(Duration(days: 1));
          break;
        case "Weekly":
          print("Weekly Case");
          scheduledDate = scheduledDate.add(Duration(days: 7));
          break;
        case "Monthly":
          print("Monthly Case");
          scheduledDate = scheduledDate.add(Duration(days: 30));
          break;
        case "Annually":
          print("Annually Case");
          scheduledDate = scheduledDate.add(Duration(days: 365));
          break;
        case "Once":
        default:
          print("default Case");
          scheduledDate = scheduledDate.add(Duration(days: 1));
          break;
      }
    }

    // Add action buttons to the notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'snooze_action',
          'Snooze',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'ignore_action',
          'Ignore',
          showsUserInterface: true,
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification.mp3',
      ),
    );

    // Define matchComponents for repetition
    DateTimeComponents? matchComponents;
    switch (frequency) {
      case "Daily":
        matchComponents = DateTimeComponents.time;
        break;
      case "Weekly":
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case "Monthly":
        matchComponents = DateTimeComponents.dayOfMonthAndTime;
        break;
      case "Annually":
        matchComponents = DateTimeComponents.dateAndTime;
        break;
      case "Once":
      default:
        matchComponents = null; // One-time notification
        break;
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchComponents,
      payload: 'notification_$id|$title|$body',
    );

    print("Notification Scheduled for: $scheduledDate, Frequency: $frequency");
  }

  // ✅ Edit a Scheduled Notification
  static Future<void> editScheduledNotification({
    required int notificationId,
    required String newTitle,
    required String newBody,
    required DateTime newStartDate,
    required TimeOfDay newStartTime,
    required String newFrequency,
  }) async {
    await cancelNotification(notificationId); // ✅ Cancel old notification
    await scheduleNotification(
      id: notificationId,
      title: newTitle,
      body: newBody,
      startDate: newStartDate,
      startTime: newStartTime,
      frequency: newFrequency,
    );
    print("Notification with ID $notificationId has been updated.");
  }

  // ✅ Cancel a Specific Notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print("Notification with ID: $id has been cancelled.");
  }

  // ✅ Cancel All Notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    print("All scheduled notifications have been cancelled.");
  }

  // ✅ Generate Unique ID
  static int generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
