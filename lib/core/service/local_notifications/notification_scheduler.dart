import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

import 'notification_initializer.dart';

Future<void> scheduleNotification({
  required String title,
  required String body,
  required String id,
  required String typeName,
  String? largeImageUrl,
}) async {
  String? imagePath = await _downloadImage(largeImageUrl);

  final notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'channel_id',
      'channel_name',
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
    888,
    title,
    body,
    notificationDetails,
    payload: payload,
  );
}

Future<String?> _downloadImage(String? url) async {
  if (url == null || url.isEmpty) return null;

  try {
    final path = join(Directory.systemTemp.path, 'large_image.jpg');
    final response = await Dio().get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
    final file = File(path);
    await file.writeAsBytes(response.data!);
    return path;
  } catch (e) {
    debugPrint('Image download failed: $e');
    return null;
  }
}
