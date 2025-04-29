import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:squeak/features/layout/layout/controller/layout_cubit.dart';
import '../../../../../features/vetcare/presenation/view/vetCareRegister.dart';
import '../../../../utils/export_path/export_files.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription? _sub;
  Widget? appStartPoint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initDeepLinkHandler(
      navigatorKey,
      _sub,
      (uri) => handleDeepLink(uri, navigatorKey),
    );
    determineStartPoint(
      context,
    ).then((screen) => setState(() => appStartPoint = screen));
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _sub?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _sub?.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        BlocProvider(create: (context) => LayoutCubit()),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final cubit = MainCubit.get(context);
          return MaterialApp(
            title: 'SQueak',
            theme: buildThemeDataLight(context),
            navigatorKey: navigatorKey,
            routes: routes,
            onGenerateRoute: (settings) {
              final uri = Uri.parse(settings.name!);
              final invitationCode =
                  uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
              CacheHelper.saveData('invitationCode', invitationCode);

              if (invitationCode.isNotEmpty) {
                return MaterialPageRoute(
                  builder:
                      (context) =>
                          VetCareRegister(invitationCode: invitationCode),
                );
              }
              return MaterialPageRoute(
                builder: (context) => appStartPoint ?? const SizedBox(),
              );
            },
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: buildThemeData(),
            debugShowCheckedModeBanner: false,
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
            navigatorObservers: [ChuckerFlutter.navigatorObserver],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}
