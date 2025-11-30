import 'package:fast_cached_network_image/fast_cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/utils/firebase_token_helper.dart';
import 'package:squeak/features/layout/notification/NotificationFCM/notification_message.dart';
import '../../../../../firebase_options.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
@pragma('vm:entry-point')
class InitFunctions {
  // Exposed current environment so other utilities can read it
  static Environment? currentEnvironment;
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Set the application environment here and expose it
    ConfigModel.setEnvironment(Environment.test);
    currentEnvironment = Environment.test;
    // propagate to other helpers that need to know environment
    DioFinalHelper.setEnvironment(Environment.test);
    Bloc.observer = MyBlocObserver();
    await _initServiceLocator();
    await _initCache(); // Initialize cache first
    await NotificationInitializer.initialize();
    await _initFirebase();
    await LocalDatabaseHelper.initDB();
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
      if (kDebugMode) {
        debugPrint('ERROR: Firebase initialization error: $e');
      }
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
      
      if (kDebugMode) {
        debugPrint('Notification permission status: ${settings.authorizationStatus}');
      }
      
      // Use FirebaseTokenHelper for robust token management
      try {
        final token = await FirebaseTokenHelper.getFirebaseToken();
        if (token != null) {
          if (kDebugMode) {
            debugPrint('SUCCESS: Firebase token obtained via helper: ${token.substring(0, 10)}...');
          }
        }
      } catch (tokenError) {
        if (kDebugMode) {
          debugPrint('WARNING: Firebase token helper error: $tokenError');
        }
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Firebase messaging initialization error: $e');
      }
    }
  }

  static Future<void> _initServiceLocator() async {
    await ServiceLocator().init();
  }

  static Future<void> _initCache() async {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory(),
    );
    await CacheHelper.init();
    await FastCachedImageConfig.init(clearCacheAfter: Duration(days: 20));
    CacheHelper.saveData('isReplayCommentOpen', false);
  }

  static Future<void> _initDio() async {
    await DioFinalHelper.init();
  }

  static Future<void> _configureChucker() async {

  }
}
