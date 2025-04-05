import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/utils/theme/dark/dark_theme_manager.dart';

import '../../../../../generated/l10n.dart';
import '../../../../utils/enums/upload_place.dart';
import '../../../../utils/theme/light/light_theme_manager.dart';
import '../../../service_locator/service_locator.dart';
import '../controller/main_cubit/main_state.dart';
import '../widgets/deep_link_handler.dart';
import '../widgets/route_generator.dart';
import 'package:image_picker/image_picker.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _initializeDeepLinkListener();
    RouteGenerator.navigateToNextScreen();
  }

  void _initializeDeepLinkListener() {
    DeepLinkHandler(appLinks: AppLinks(), navigatorKey: navigatorKey).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return sl<MainCubit>()
          ..changeAppMode(fromShared: CacheHelper.getData('isDark') ?? false)
          ..changeAppLang(
            fromSharedLang: CacheHelper.getData('language') ?? 'en',
          )..requestNotificationPermissions();
      },

      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MainCubit.get(context);
          return MaterialApp(
            title: 'SQueak',
            theme: buildThemeDataLight(context),
            navigatorKey: navigatorKey,
            // add routes screen
            //routes: routes,
            home: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {

                },
                child: const Icon(Icons.dark_mode, color: Colors.white),
              ),
            ),
            // onGenerateRoute: RouteGenerator.generateRoute,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: buildThemeData(),
            locale:
                MainCubit.get(context).language == 'en'
                    ? const Locale('en')
                    : const Locale('ar'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            navigatorObservers: [ChuckerFlutter.navigatorObserver],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}
