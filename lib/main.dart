import 'package:flutter/services.dart';
import 'package:squeak/core/service/main_service/presentation/widgets/init_functions.dart';
import 'package:flutter/material.dart';
import 'core/service/main_service/presentation/screens/app_view.dart';

Future<void> main() async {
  await InitFunctions.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

