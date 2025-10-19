import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/utils/firebase_token_helper.dart';
import 'package:squeak/core/utils/enums/env_enums.dart';
import 'package:squeak/core/utils/debug_utils.dart';
import 'package:squeak/features/layout/notification/NotificationFCM/notification_message.dart';
import '../../../../../firebase_options.dart';

@pragma('vm:entry-point')
class InitFunctions {
  static Environment currentEnvironment = Environment.pro;
  
  /// Set the environment for the application
  /// Use Environment.test to enable chucker, Environment.pro to disable it
  static void setEnvironment(Environment env) {
    currentEnvironment = env;
  }
  
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Don't override currentEnvironment here - use the one set in setEnvironment() or the default
    ConfigModel.setEnvironment(currentEnvironment);
        Bloc.observer = MyBlocObserver();
    await _initServiceLocator();
    await _initCache(); // Initialize cache first
    await NotificationInitializer.initialize();
    await _initFirebase();
    await LocalDatabaseHelper.initDB();
    await _configureChucker(); // Configure chucker first
    await _initDio(); // Then initialize Dio with chucker configuration
    await _setupMessaging();
  }

  static Future<void> _setupMessaging() async {
    _listenToForegroundMessages();
    _listenToBackgroundMessages();
    _listenToMessageOpenedApp();
  }

  static void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // print('app foreground');
      _handleMessage(message);
    });
  }

  @pragma('vm:entry-point')
  static void _listenToMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // print('app opened');
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
    // print('app Terminated');

    _handleMessage(message);
  }

  @pragma('vm:entry-point')
  static void _handleMessage(RemoteMessage message) async {
    // print('Message received: ${message.toMap()}\n \n \n');
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
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Initialize Firebase messaging with proper permissions
      await _initializeFirebaseMessaging();
      
    } catch (e) {
      DebugUtils.debugPrintEnv('ERROR: Firebase initialization error: $e');
    }
  }

  static Future<void> _initializeFirebaseMessaging() async {
    try {
      final messaging = FirebaseMessaging.instance;
      
      // Request permissions for notifications
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      
      DebugUtils.debugPrintEnv('Notification permission status: ${settings.authorizationStatus}');
      
      // Use FirebaseTokenHelper for robust token management
      try {
        final token = await FirebaseTokenHelper.getFirebaseToken();
        if (token != null) {
          DebugUtils.debugPrintEnv('SUCCESS: Firebase token obtained via helper: ${token.substring(0, 10)}...');
        }
      } catch (tokenError) {
        DebugUtils.debugPrintEnv('WARNING: Firebase token helper error: $tokenError');
      }
      
    } catch (e) {
      DebugUtils.debugPrintEnv('ERROR: Firebase messaging initialization error: $e');
    }
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
    // Set environment in DioFinalHelper before initialization
    DioFinalHelper.setEnvironment(currentEnvironment);
    await DioFinalHelper.init();
  }

  static Future<void> _configureChucker() async {
    // Configure chucker based on environment
    // Enable chucker only in test environment for debugging network requests
    // Disable in production and pre-production environments for security and performance
    
    DebugUtils.debugPrintEnv('INFO: Configuring Chucker for environment: ${currentEnvironment.name}');
    
    if (currentEnvironment == Environment.test) {
      ChuckerFlutter.showOnRelease = true;
      ChuckerFlutter.showNotification = true;
      
      DebugUtils.debugPrintEnv('SUCCESS: Chucker enabled for test environment');
      DebugUtils.debugPrintEnv('  - showOnRelease: ${ChuckerFlutter.showOnRelease}');
      DebugUtils.debugPrintEnv('  - showNotification: ${ChuckerFlutter.showNotification}');
    } else {
      ChuckerFlutter.showOnRelease = false;
      ChuckerFlutter.showNotification = false;
      
      DebugUtils.debugPrintEnv('INFO: Chucker disabled for ${currentEnvironment.name} environment');
      DebugUtils.debugPrintEnv('  - showOnRelease: ${ChuckerFlutter.showOnRelease}');
      DebugUtils.debugPrintEnv('  - showNotification: ${ChuckerFlutter.showNotification}');
    }
  }
}
