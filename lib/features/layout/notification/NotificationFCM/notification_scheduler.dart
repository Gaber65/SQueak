// notification_scheduler.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:path/path.dart';
import 'notification_initializer.dart';

class NotificationScheduler {

  /// Schedule instant notification (for Firebase messages)
  static Future<void> scheduleInstantNotification({
    required String title,
    required String body,
    required String id,
    required String typeName,
    String? largeImageUrl,
    int notificationId = 888,
  }) async {
    String? imagePath = await _downloadImage(largeImageUrl);

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel_id',
        'Instant Notifications',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: imagePath != null
            ? BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          largeIcon: FilePathAndroidBitmap(imagePath),
          contentTitle: title,
          summaryText: body,
        )
            : null,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
      ),
      iOS: DarwinNotificationDetails(
        attachments: imagePath != null ? [DarwinNotificationAttachment(imagePath)] : [],
        sound: 'notification.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final payload = '{"id": "$id", "typeName": "$typeName"}';

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    print("Instant notification scheduled: $title");
  }

  /// Schedule reminder notification with frequency
  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime startDate,
    required TimeOfDay startTime,
    required String frequency, // "Once", "Daily", "Weekly", "Monthly", "Annually"
  }) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.getLocation('Africa/Cairo'),
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );

    print("Scheduling reminder for: ${startDate.year}/${startDate.month}/${startDate.day} ${startTime.hour}:${startTime.minute}");

    // Ensure the scheduled date is in the future
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = _adjustScheduledDate(scheduledDate, frequency);
    }

    // Create notification with action buttons
    const AndroidNotificationDetails androidDetails =
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
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification.mp3',
      ),
    );

    // Define repetition pattern
    DateTimeComponents? matchComponents = _getMatchComponents(frequency);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchComponents,
      payload: 'reminder_$id|$title|$body',
    );

    print("Reminder scheduled for: $scheduledDate, Frequency: $frequency");
  }

  /// Edit a scheduled notification
  static Future<void> editScheduledNotification({
    required int notificationId,
    required String newTitle,
    required String newBody,
    required DateTime newStartDate,
    required TimeOfDay newStartTime,
    required String newFrequency,
  }) async {
    // Cancel the existing notification
    await flutterLocalNotificationsPlugin.cancel(notificationId);

    // Schedule the updated notification
    await scheduleReminderNotification(
      id: notificationId,
      title: newTitle,
      body: newBody,
      startDate: newStartDate,
      startTime: newStartTime,
      frequency: newFrequency,
    );

    print("Notification with ID $notificationId has been updated.");
  }

  /// Download image for notification
  static Future<String?> _downloadImage(String? url) async {
    if (url == null || url.isEmpty) return null;

    try {
      final path = join(Directory.systemTemp.path, 'notification_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final file = File(path);
      await file.writeAsBytes(response.data!);
      return path;
    } catch (e) {
      debugPrint('Image download failed: $e');
      return null;
    }
  }

  /// Adjust scheduled date if it's in the past
  static tz.TZDateTime _adjustScheduledDate(tz.TZDateTime scheduledDate, String frequency) {
    switch (frequency) {
      case "Daily":
        return scheduledDate.add(Duration(days: 1));
      case "Weekly":
        return scheduledDate.add(Duration(days: 7));
      case "Monthly":
        return scheduledDate.add(Duration(days: 30));
      case "Annually":
        return scheduledDate.add(Duration(days: 365));
      case "Once":
      default:
        return scheduledDate.add(Duration(days: 1));
    }
  }

  /// Get match components for repetition pattern
  static DateTimeComponents? _getMatchComponents(String frequency) {
    switch (frequency) {
      case "Daily":
        return DateTimeComponents.time;
      case "Weekly":
        return DateTimeComponents.dayOfWeekAndTime;
      case "Monthly":
        return DateTimeComponents.dayOfMonthAndTime;
      case "Annually":
        return DateTimeComponents.dateAndTime;
      case "Once":
      default:
        return null; // One-time notification
    }
  }
}