import 'package:flutter/services.dart';
import 'package:squeak/core/service/main_service/presentation/widgets/init_functions.dart';
import 'package:squeak/core/monitoring/advanced_performance_monitor.dart';
import 'package:flutter/material.dart';
import 'core/service/main_service/presentation/screens/app_view.dart';

Future<void> main() async {
  await InitFunctions.initialize();
  
  // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
  // await AdvancedPerformanceMonitor().initialize();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

