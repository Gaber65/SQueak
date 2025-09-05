import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/notification/NotificationFCM/notification_message.dart';
import '../../../../../firebase_options.dart';

@pragma('vm:entry-point')
class InitFunctions {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    ConfigModel.setEnvironment(Environment.test);
    Bloc.observer = MyBlocObserver();
    await _initServiceLocator();
    await NotificationInitializer.initialize();
    await _initFirebase();
    await LocalDatabaseHelper.initDB();
    await _initCache();
    await _initDio();
    await _configureChucker();
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
      _handleMessage(message);
    });
  }

  @pragma('vm:entry-point')
  static void _listenToMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('app opened');
      _handleMessage(message);
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

    _handleMessage(message);
  }

  @pragma('vm:entry-point')
  static void _handleMessage(RemoteMessage message) async {
    print('Message received: ${message.toMap()}\n \n \n');
    final model = NotificationMessage.fromJson(message.toMap());

    NotificationScheduler.scheduleInstantNotification(
      title: model.data!.title!,
      body: model.data!.body!,
      id: model.data!.targetTypeId!,
      typeName: model.data!.targetType!,
      largeImageUrl: model.data!.imageUrl!,
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

  static Future<void> _initCache() async {
    await CacheHelper.init();
    await FastCachedImageConfig.init(clearCacheAfter: Duration(days: 20));
    CacheHelper.saveData('isReplayCommentOpen', false);
  }

  static Future<void> _initDio() async {
    await DioFinalHelper.init();
  }

  static Future<void> _configureChucker() async {
    ChuckerFlutter.showOnRelease = false;
    ChuckerFlutter.showNotification = true;
  }
}
