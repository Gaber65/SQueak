import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:squeak/core/service/connectivity/conectivity_services.dart';
import 'core/service/service_locator/locatore_export_path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await InitFunctions.initialize();
  bool addNew = false;
  if (addNew) {
    CacheHelper.saveData(
      'token',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkJlYXJlciJ9.eyJ1bmlxdWVfbmFtZSI6Im1tbXM3Nzk5MEBnbWFpbC5jb20iLCJuYW1laWQiOiIzYjliNmRlMy02Zjk4LTRjYWItODhlMy0zZWZiNzQxMDIyYzIiLCJzdWIiOiJtbW1zNzc5OTBAZ21haWwuY29tIiwibmJmIjoxNzYzNTYyNjg3LCJleHAiOjE3OTUwOTg2ODcsImp0aSI6IjE3MzczNDkyLWYyNWItNDJkMS04Yjk5LTdiNWVmMjc5MDMxNyIsImlhdCI6MTc2MzU2MjY4NywiaXNzIjoiaHR0cDovL2FvbWFyMjAxMC0wMDEtc2l0ZTEuYnRlbXB1cmwuY29tLyJ9.-hAp7mNZdsil7HTOHRLUgeD2OuTfsEx9EuEsQNW2UTo',
    );
  }
  ConnectivityService().startMonitoring();

  if (kDebugMode) {
    print(CacheHelper.getData('token'));

    // Print owner id from cached Owner data
    try {
      final ownerData = CacheHelper.getData('Owner');
      if (ownerData != null) {
        final Map<String, dynamic> ownerMap = jsonDecode(ownerData);
        print('Owner id: ${ownerMap['id']}');
      } else {
        // Fallback to clintId if Owner not cached yet
        print('Owner id (clintId): ${CacheHelper.getData('clintId')}');
      }
    } catch (e) {
      print('Error reading owner id: $e');
    }
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}
