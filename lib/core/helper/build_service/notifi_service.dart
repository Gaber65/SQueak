// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:squeak/core/helper/build_service/firebase_messaging_handler.dart';
// import 'package:squeak/core/thames/styles.dart';
// import 'package:squeak/features/layout/view/feeds/post_notfication.dart';
// import 'package:squeak/features/layout/view/notifications/notificationPage.dart';
// import 'package:squeak/features/vetcare/view/follow_request_screen.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:path/path.dart';
// import '../../../features/pets/view/pet_screen.dart';
// import 'app_view.dart';

// String? initialNotificationPayload;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// @pragma('vm:entry-point')
// void backgroundHandler(NotificationResponse details) {
//   print('Received notification with app Terminated: ${details.payload}');

//   final payload = details.payload!;
//   handleNavigation(payload);
// }

// Future<void> initNotifications() async {
//   const initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   tz.initializeTimeZones();

//   var initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) async {}),
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       print('Received notification with ID: ${response.payload}');

//       final payload = response.payload!;
//       handleNavigation(payload);
//     },
//   );
//   // Handle terminated notification interaction
//   final NotificationAppLaunchDetails? details =
//       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//   if (details?.didNotificationLaunchApp ?? false) {
//     initialNotificationPayload = details!.notificationResponse?.payload;
//   }
// }
// // Future<void> initNotifications() async {
// //   tz.initializeTimeZones();

// //   const AndroidInitializationSettings androidSettings =
// //       AndroidInitializationSettings('@mipmap/ic_launcher');

// //   const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
// //     requestAlertPermission: true,
// //     requestBadgePermission: true,
// //     requestSoundPermission: true,
// //   );

// //   final InitializationSettings settings = InitializationSettings(
// //     android: androidSettings,
// //     iOS: iosSettings,
// //   );

// //   await flutterLocalNotificationsPlugin.initialize(
// //     settings,
// //     onDidReceiveNotificationResponse: (NotificationResponse response) async {
// //       print('Received notification with ID: ${response.payload}');
// //       if (response.payload != null) {
// //         handleNavigation(response.payload!);
// //       }
// //     },
// //   );

// //   // Handle notification when the app is launched from a terminated state
// //   final NotificationAppLaunchDetails? details =
// //       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
// //   if (details?.didNotificationLaunchApp ?? false) {
// //     initialNotificationPayload = details!.notificationResponse?.payload;
// //   }
// // }

// final BigPictureStyleInformation bigPictureStyleInformation =
//     BigPictureStyleInformation(
//   const DrawableResourceAndroidBitmap('large_image'),
//   largeIcon:
//       const DrawableResourceAndroidBitmap('small_image'), // Set the small image
//   contentTitle: 'Your Notification Title',
//   summaryText: 'Your Notification Summary',
// );

// @pragma('vm:entry-point')
// Future<void> scheduleMarchNotification({
//   required String title,
//   required String body,
//   required String id,
//   required String typeName,
//   String? largeImageUrl,
// }) async {
//   String? largeImagePath;
//   if (largeImageUrl != null && largeImageUrl.isNotEmpty) {
//     largeImagePath =
//         await downloadAndSaveFile(largeImageUrl, 'large_image.jpg');
//   }

//   final String? validFilePath =
//       largeImagePath != null && File(largeImagePath).existsSync()
//           ? largeImagePath
//           : null;

//   final BigPictureStyleInformation? bigPictureStyleInformation =
//       validFilePath != null
//           ? BigPictureStyleInformation(
//               FilePathAndroidBitmap(validFilePath),
//               largeIcon: FilePathAndroidBitmap(validFilePath),
//               contentTitle: title,
//               summaryText: body,
//             )
//           : null;

//   final DarwinNotificationAttachment? attachment = validFilePath != null
//       ? DarwinNotificationAttachment(validFilePath)
//       : null;

//   final AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.max,
//     playSound: true,
//     sound: const RawResourceAndroidNotificationSound('notification'),
//     priority: Priority.high,
//     styleInformation: bigPictureStyleInformation,
//   );

//   final NotificationDetails notificationDetails = NotificationDetails(
//     android: androidNotificationDetails,
//     iOS: DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'notification.mp3',
//       attachments: attachment != null ? [attachment] : [],
//     ),
//   );

//   String payload = '{"id": "$id", "typeName": "$typeName"}';

//   await flutterLocalNotificationsPlugin.show(
//     888,
//     title,
//     body,
//     notificationDetails,
//     payload: payload,
//   );
// }

// Future<String> downloadAndSaveFile(String url, String fileName) async {
//   try {
//     final Directory tempDir = Directory.systemTemp;
//     final String filePath = join(tempDir.path, fileName);
//     final Dio dio = Dio();

//     final Response<List<int>> response = await dio.get<List<int>>(
//       url,
//       options: Options(responseType: ResponseType.bytes),
//     );

//     final File file = File(filePath);
//     await file.writeAsBytes(response.data!);
//     return filePath;
//   } catch (e) {
//     print('File download failed: $e');
//     return ''; // Return an empty string if the download fails
//   }
// }

// void handleNavigation(String payload) {
//   // Parse the JSON payload
//   final Map<String, dynamic> data = jsonDecode(payload);

//   // Extract the ID and typeName
//   final String id = data['id'] ?? '';
//   final String typeName = data['typeName'] ?? '';

//   print('Received notification with ID: $id and typeName: $typeName');
//   // Retrieve the NotificationType from typeName
//   final NotificationType? type =
//       FirebaseMessagingHandler.getNotificationType(typeName);

//   // Ensure the context is available
//   final BuildContext? context = navigatorKey.currentContext;

//   // Handle navigation based on notification type
//   switch (type) {
//     case NotificationType.NewAppointmentOrReservation:
//     case NotificationType.AppointmentCompleted:
//     case NotificationType.ReservationReminder:
//       getAppointment(
//         id: id,
//         type: type!,
//         isNav: true,
//         context: context!,
//       );
//       break;

//     case NotificationType.NewPetAdded:
//     case NotificationType.VaccinationReminder:
//       navigateToScreen(context!, PetScreen());
//       break;
//     case NotificationType.NewPostAdded:
//     case NotificationType.NewCommentOnPost:
//       navigateToScreen(context!, PostNotification(id: id));
//       break;

//     case NotificationType.FollowRequest:
//       print('Handling follow request: $id');
//       navigateToScreen(context!, FollowRequestScreen(ClinicID: id));
//       break;
//     default:
//       break;
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:squeak/core/helper/build_service/firebase_messaging_handler.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/layout/view/feeds/post_notfication.dart';
import 'package:squeak/features/layout/view/notifications/notificationPage.dart';
import 'package:squeak/features/vetcare/view/follow_request_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
//import 'package:workmanager/workmanager.dart'; // New: Import Workmanager

import '../../../features/pets/view/pet_screen.dart';
import 'app_view.dart';

String? initialNotificationPayload;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  print('Received notification with app Terminated: ${details.payload}');

  final payload = details.payload!;
  handleNavigation(payload);
}

Future<void> initNotifications() async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  tz.initializeTimeZones();

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {}),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      print('Received notification with ID: ${response.payload}');

      final payload = response.payload!;
      handleNavigation(payload);
    },
  );

  // Handle terminated notification interaction
  final NotificationAppLaunchDetails? details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (details?.didNotificationLaunchApp ?? false) {
    initialNotificationPayload = details!.notificationResponse?.payload;
  }
}

// New: Initialize Workmanager for background notifications
Future<void> initializeWorkManager() async {
  // await Workmanager().initialize(
  //   callbackDispatcher, // Background execution function
  //   isInDebugMode: true, // Set to false in production
  // );
  //
  // await registerBackgroundNotificationTask();
}

// New: Register periodic notification check task
Future<void> registerBackgroundNotificationTask() async {
  // await Workmanager().registerPeriodicTask(
  //   "background_notification_task",
  //   "fetchNewNotifications",
  //   frequency: Duration(minutes: 15), // Minimum interval in iOS is 15 minutes
  // );
}

// New: Callback for background task execution
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Workmanager().executeTask((task, inputData) async {
  //   print("Executing background notification task: $task");
  //
  //   // Example: Check for new notifications and display them
  //   await scheduleMarchNotification(
  //     title: "New Notification",
  //     body: "You have a new update!",
  //     id: "123",
  //     typeName: "NewPostAdded",
  //   );
  //
  //   return Future.value(true);
  // });
}

final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
  const DrawableResourceAndroidBitmap('large_image'),
  largeIcon:
      const DrawableResourceAndroidBitmap('small_image'), // Set the small image
  contentTitle: 'Your Notification Title',
  summaryText: 'Your Notification Summary',
);

@pragma('vm:entry-point')
Future<void> scheduleMarchNotification({
  required String title,
  required String body,
  required String id,
  required String typeName,
  String? largeImageUrl,
}) async {
  String? largeImagePath;
  if (largeImageUrl != null && largeImageUrl.isNotEmpty) {
    largeImagePath =
        await downloadAndSaveFile(largeImageUrl, 'large_image.jpg');
  }

  final String? validFilePath =
      largeImagePath != null && File(largeImagePath).existsSync()
          ? largeImagePath
          : null;

  final BigPictureStyleInformation? bigPictureStyleInformation =
      validFilePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(validFilePath),
              largeIcon: FilePathAndroidBitmap(validFilePath),
              contentTitle: title,
              summaryText: body,
            )
          : null;

  final DarwinNotificationAttachment? attachment = validFilePath != null
      ? DarwinNotificationAttachment(validFilePath)
      : null;

  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.max,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('notification'),
    priority: Priority.high,
    styleInformation: bigPictureStyleInformation,
  );

  final NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification.mp3',
      attachments: attachment != null ? [attachment] : [],
    ),
  );

  String payload = '{"id": "$id", "typeName": "$typeName"}';

  await flutterLocalNotificationsPlugin.show(
    888,
    title,
    body,
    notificationDetails,
    payload: payload,
  );
}

Future<String> downloadAndSaveFile(String url, String fileName) async {
  try {
    final Directory tempDir = Directory.systemTemp;
    final String filePath = join(tempDir.path, fileName);
    final Dio dio = Dio();

    final Response<List<int>> response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    final File file = File(filePath);
    await file.writeAsBytes(response.data!);
    return filePath;
  } catch (e) {
    print('File download failed: $e');
    return ''; // Return an empty string if the download fails
  }
}

void handleNavigation(String payload) {
  // Parse the JSON payload
  final Map<String, dynamic> data = jsonDecode(payload);

  // Extract the ID and typeName
  final String id = data['id'] ?? '';
  final String typeName = data['typeName'] ?? '';

  print('Received notification with ID: $id and typeName: $typeName');
  // Retrieve the NotificationType from typeName
  final NotificationType? type =
      FirebaseMessagingHandler.getNotificationType(typeName);

  // Ensure the context is available
  final BuildContext? context = navigatorKey.currentContext;

  // Handle navigation based on notification type
  switch (type) {
    case NotificationType.NewAppointmentOrReservation:
    case NotificationType.AppointmentCompleted:
    case NotificationType.ReservationReminder:
      getAppointment(
        id: id,
        type: type!,
        isNav: true,
        context: context!,
      );
      break;

    case NotificationType.NewPetAdded:
    case NotificationType.VaccinationReminder:
      navigateToScreen(context!, PetScreen());
      break;
    case NotificationType.NewPostAdded:
    case NotificationType.NewCommentOnPost:
      navigateToScreen(context!, PostNotification(id: id));
      break;

    case NotificationType.FollowRequest:
      print('Handling follow request: $id');
      navigateToScreen(context!, FollowRequestScreen(ClinicID: id));
      break;
    default:
      break;
  }
}
