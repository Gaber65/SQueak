// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:squeak/core/helper/remotely/config_model.dart';
// import 'core/helper/bloc_observe/observe.dart';
// import 'core/helper/build_service/app_view.dart';
// import 'core/helper/build_service/firebase_service.dart';
// import 'package:flutter/services.dart';

// import 'core/helper/build_service/notification_service.dart';
// import 'core/helper/local_db/local_database.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Bloc.observer = MyBlocObserver();
//   ConfigModel.setEnvironment(Environment.test);
//   await FirebaseService.initialize();
//   await LocalDatabaseHelper.initDB();
//   await NotificationService.init();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]).then((_) {
//     runApp(MyApp());
//   });
// }
// /*
// Steps to production:
// 1. make the Environment = pro.
// 2. ChuckerFlutter.showOnRelease = false;
//  */
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

import 'core/helper/bloc_observe/observe.dart';
import 'core/helper/build_service/app_view.dart';
import 'core/helper/build_service/firebase_service.dart';
import 'core/helper/build_service/notification_service.dart';
import 'core/helper/local_db/local_database.dart';
import 'core/helper/remotely/config_model.dart';
import 'firebase_options.dart';

// ✅ Background notification handler (Runs when app is terminated or in background)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🛠 Background Notification Received: ${message.notification?.title}");
}

// ✅ Initialize local notifications for showing push notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// ✅ Function to handle foreground notifications
void _setupForegroundNotificationHandler() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        "🔥 Foreground Notification Received: ${message.notification?.title}");

    // Show local notification when app is in foreground
    if (message.notification != null) {
      _showLocalNotification(message);
    }
  });
}

// ✅ Show local notification
void _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    message.notification?.title ?? "New Notification",
    message.notification?.body ?? "You have a new message",
    platformDetails,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Required for async operations

  Bloc.observer = MyBlocObserver(); // ✅ Observes Bloc state changes
  ConfigModel.setEnvironment(Environment.test); // ✅ Set environment mode

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // ✅ Initialize Firebase
  await FirebaseService.initialize(); // ✅ Initialize Firebase-related services
  await LocalDatabaseHelper.initDB(); // ✅ Initialize local database
  await NotificationService.init(); // ✅ Initialize notification service

  // ✅ Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Request permissions for notifications (iOS requirement)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("✅ Notifications permission granted");
  } else {
    print("❌ Notifications permission denied");
  }

  // ✅ Handle foreground notifications
  _setupForegroundNotificationHandler();

  // ✅ Set preferred screen orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp()); // ✅ Start the app
  });
}
