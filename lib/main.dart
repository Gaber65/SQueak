import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'core/service/service_locator/locatore_export_path.dart';

Future<void> main() async {
  await InitFunctions.initialize();

// print(CacheHelper.getData('token'));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}
