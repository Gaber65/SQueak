import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:app_links/app_links.dart';

import '../../../../../features/auth/login/presentation/pages/login_screen.dart';
import '../../../../utils/export_path/export_files.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
StreamSubscription? sub;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget? appStartPoint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize deep link listener
    final appLinks = AppLinks();
    sub = appLinks.uriLinkStream.listen(
      (uri) => handleDeepLink(uri, navigatorKey),
      onError: (e) => print('DeepLink Error: $e'),
    );
    appLinks.getInitialLink().then((uri) {
      if (uri != null) handleDeepLink(uri, navigatorKey);
    });

    determineStartState().then((state) {
      Widget startWidget;
      switch (state) {
        case AppStartState.login:
          startWidget = LoginScreen();
          break;
        case AppStartState.home:
          startWidget = LayoutScreen();
          break;
      }

      setState(() {
        appStartPoint = startWidget;
      });
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      sub?.pause();
    } else if (state == AppLifecycleState.resumed) {
      sub?.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appStartPoint == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return sl<MainCubit>()
              ..changeAppMode(
                fromShared: CacheHelper.getData('isDark') ?? false,
              )
              ..changeAppLang(
                fromSharedLang: CacheHelper.getData('language') ?? 'en',
              )
              ..requestNotificationPermissions();
          },
        ),
        BlocProvider(
          create:
              (context) =>
                  sl<LayoutCubit>()
                    ..getAppVersion()
                    ..getVersion(),
        ),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final cubit = MainCubit.get(context);
          return MaterialApp(
            title: 'SQueak',
            theme: buildThemeDataLight(context),
            darkTheme: buildThemeData(),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            home: appStartPoint,
            locale:
                cubit.language == 'en'
                    ? const Locale('en')
                    : const Locale('ar'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            navigatorObservers: [ChuckerFlutter.navigatorObserver],
          );
        },
      ),
    );
  }
}
