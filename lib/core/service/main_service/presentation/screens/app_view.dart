import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:squeak/features/appointments/data/models/appointment_model.dart';
import 'package:squeak/features/appointments/presentation/view/appointments/rate_appointment.dart';
import '../../../../../features/auth/login/presentation/pages/login_screen.dart';
import '../../../../../features/vetcare/presenation/view/pet_merge_screen.dart';
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

    determineStartState().then((state) async {
      Widget startWidget;

      switch (state) {
        case AppStartState.login:
          startWidget = LoginScreen();
          break;
        case AppStartState.forceMerge:
          final String code = CacheHelper.getData('CodeForce');
          startWidget = PetMergeScreen(code: code, isNavigation: false);
          break;
        case AppStartState.forceRate:
          String dataJson = await CacheHelper.getData('RateModel');
          final model = AppointmentModel.fromJson(json.decode(dataJson));
          startWidget = RateAppointment(isNav: false, model: model);
          break;
        case AppStartState.home:
          startWidget = LayoutScreen();
          break;
      }

      setState(() => appStartPoint = startWidget);
    });
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
            navigatorKey: navigatorKey,
            routes: routes,
            onGenerateRoute: (settings) {
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
