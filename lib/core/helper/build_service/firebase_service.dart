import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:squeak/core/constant/global_function/token_manager.dart';
import 'package:squeak/core/helper/build_service/firebase_messaging_handler.dart';
import 'package:squeak/core/helper/remotely/dio.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/view/notifications/notificationPage.dart';
// import 'package:workmanager/workmanager.dart';
import '../../../features/appointments/models/notfication_model.dart';
import '../../../firebase_options.dart';
import '../cache/cache_helper.dart';
import 'app_view.dart';
import 'notifi_service.dart';

bool _isInitialized = false;

class FirebaseService {
  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    if (_isInitialized) return; // Add a flag to ensure one-time setup
    _isInitialized = true;
    await _initFirebase();
    await _initCache();
    await _initDio();
    await _configureChucker();
    await _setupMessaging();
    _setupWorkManager();
    await initNotifications();
    await _saveFCMToken();
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
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
      RemoteMessage message) async {
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
      case "NewPetAdded":
        _getPetsAfterAsync();
        break;
    }
  }

  static void _handleAppointment(targetTypeId, bool isAppOpen) {
    if (isAppOpen) {
      print("Rate open ");
      getAppointment(
        id: targetTypeId,
        isNav: false,
        type: NotificationType.AppointmentCompleted,
        context: navigatorKey.currentContext!,
      );
    } else {
      print("Rate not open ");
      getAppointmentWithoutNav(
        id: targetTypeId,
        isNav: false,
        type: NotificationType.AppointmentCompleted,
      );
    }
  }

  static void _getPetsAfterAsync() {
    LayoutCubit.get(navigatorKey.currentContext!).getOwnerPet();
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

  static Future<void> _saveFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Retrieve the APNS token
    String? apnsToken = await messaging.getAPNSToken();
    print("APNS Token: $apnsToken");
    final token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    CacheHelper.saveData('DeviceToken', token);
  }
}
