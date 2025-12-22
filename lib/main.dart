import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'core/service/service_locator/locatore_export_path.dart';

Future<void> main() async {
  await InitFunctions.initialize();
  final details =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (details?.didNotificationLaunchApp ?? false) {
    initialNotificationPayload = details!.notificationResponse?.payload;
    print("App launched from notification: $initialNotificationPayload");
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}
