import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/notification/NotificationFCM/notification_message.dart';
import '../../../../../features/layout/notification/NotificationAPI/presentation/widget/get_appoiment_function.dart';
import '../../../../../features/layout/notification/NotificationFCM/notification_initializer.dart';
import '../../../../../firebase_options.dart';

class InitFunctions {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    ConfigModel.setEnvironment(Environment.test);
    Bloc.observer = MyBlocObserver();
    await _initServiceLocator();
    await initNotifications();
    await _initFirebase();
    await LocalDatabaseHelper.initDB(); // ✅ Initialize local database
    await _initCache();
    await _initDio();
    await _configureChucker();
    _setupWorkManager();
    await _setupMessaging();
  }

  static Future<void> _setupMessaging() async {
    _listenToForegroundMessages();
    _listenToBackgroundMessages();
    _listenToMessageOpenedApp();
  }

  static void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('app foreground');
      _handleMessage(message, true);
    });
  }

  @pragma('vm:entry-point')
  static void _listenToMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('app opened');
      _handleMessage(message, true);
    });
  }

  @pragma('vm:entry-point')
  static void _listenToBackgroundMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print('app Terminated');

    _handleMessage(message, false);
  }

  @pragma('vm:entry-point')
  static void _handleMessage(RemoteMessage message, bool isAppOpen) async {
    print('Message received: ${message.toMap()}');
    final model = NotificationMessage.fromJson(message.toMap());

    FirebaseMessagingHandler.handleNotification(
      model.data!.title!,
      model.data!.body!,
      model.data!.imageUrl!,
      model.data!.targetTypeId!,
      model.data!.targetType!,
    );
    await CacheHelper.init();

    switch (model.data!.targetType) {
      case "AppointmentCompleted":
        CacheHelper.saveData('IsForceRate', true);
        _handleAppointment(model.data!.targetTypeId!, isAppOpen);
        break;
    }
  }

  static void _handleAppointment(targetTypeId, bool isAppOpen) {
    getAppointment(
      id: targetTypeId,
      isNav: false,
      type: NotificationType.AppointmentCompleted,
      context: navigatorKey.currentContext!,
    );
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> _initServiceLocator() async {
    await ServiceLocator().init();
  }

  static void _setupWorkManager() {
    // Workmanager().initialize(ReminderManager.callbackDispatcher,
    //     isInDebugMode: kDebugMode);
    //
    // Workmanager().registerPeriodicTask(
    //   '1',
    //   'refreshTokenTask',
    //   frequency: Duration(hours: 4),
    //   initialDelay: Duration(seconds: 10),
    //   constraints: Constraints(networkType: NetworkType.connected),
    // );
  }
  static Future<void> _initCache() async {
    await CacheHelper.init();
    await FastCachedImageConfig.init(clearCacheAfter: Duration(days: 20));
    CacheHelper.saveData('isReplayCommentOpen', false);
  }

  static Future<void> _initDio() async {
    await DioFinalHelper.init();
  }

  static Future<void> _configureChucker() async {
    ChuckerFlutter.showOnRelease = true;
    ChuckerFlutter.showNotification = true;
  }
}
