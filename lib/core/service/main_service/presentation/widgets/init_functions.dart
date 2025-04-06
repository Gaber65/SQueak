import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
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
