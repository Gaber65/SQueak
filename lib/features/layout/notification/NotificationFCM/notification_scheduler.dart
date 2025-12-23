import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:path/path.dart';
import '../NotificationAPI/domain/entities/notification_entities.dart';
import 'notification_initializer.dart';

class NotificationScheduler {
  /// Schedule instant notification (for Firebase messages)
  static Future<void> scheduleInstantNotification({
    required NotificationEntities entites,

    int notificationId = 888,
  }) async {
    String? imagePath = await _downloadImage(entites.logo);

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel_id',
        'Instant Notifications',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation:
            imagePath != null
                ? BigPictureStyleInformation(
                  FilePathAndroidBitmap(imagePath),
                  largeIcon: FilePathAndroidBitmap(imagePath),
                  contentTitle: entites.title,
                  summaryText: entites.message,
                )
                : null,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
      ),
      iOS: DarwinNotificationDetails(
        attachments:
            imagePath != null ? [DarwinNotificationAttachment(imagePath)] : [],
        sound: 'notification.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      entites.title,
      entites.message,
      notificationDetails,
      payload: jsonEncode(entites.toJson()),
    );

  }

  /// Schedule reminder notification with frequency
  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime startDate,
    required TimeOfDay startTime,
    required String
    frequency, // "Once", "Daily", "Weekly", "Monthly", "Annually"
  }) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.getLocation('Africa/Cairo'),
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );


    // Ensure the scheduled data is in the future
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

    // Define repetition pattern
    _getMatchComponents(frequency);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'reminder_$id|$title|$body',
    );

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

  }

  /// Download image for notification
  static Future<String?> _downloadImage(String? url) async {
    if (url == null || url.isEmpty) return null;

    try {
      final path = join(
        Directory.systemTemp.path,
        'notification_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
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

  /// Adjust scheduled data if it's in the past
  static tz.TZDateTime _adjustScheduledDate(
    tz.TZDateTime scheduledDate,
    String frequency,
  ) {
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
