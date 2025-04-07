import 'dart:async';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:squeak/core/helper/build_service/routes.dart';
import 'package:squeak/features/QR/view/follow-confirmation_screen.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:app_links/app_links.dart';
import 'package:squeak/features/vetcare/view/vetCareRegister.dart';
import 'package:squeak/features/QR/view/qr_register_screen.dart';
import 'package:squeak/generated/l10n.dart';
import 'package:squeak/core/thames/theme_manager.dart';
import '../../../features/authentication/view/login_screen.dart';
import '../../../features/layout/layout.dart';
import '../../../features/vetcare/view/pet_merge_screen.dart';
import '../../constant/global_function/global_function.dart';
import '../cache/cache_helper.dart';
import 'main_cubit/main_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription? _sub;
  final appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDeepLinkListener();
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void _initDeepLinkListener() {
    if (!kIsWeb) {
      _sub = appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      }, onError: (err) {
        print('Failed to get latest link: $err.');
      });
    }

    appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }).catchError((err) {
      print('Failed to get initial link: $err.');
    });
  }

  void _handleDeepLink(Uri uri) {
    print("Received deep link: $uri");
    final extractedParams = extractQueryParams(uri.toString());

    String? clinicCode = extractedParams['qrClinicCode'];
    String? clinicName = extractedParams['clinicName'];
    String? clinicLogo = extractedParams['clinicLogo'];

    if (clinicCode != null && clinicName != null && clinicLogo != null) {
      if (CacheHelper.getData('token') == null) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RegisterQrScreen(
              clinicCode: clinicCode,
              clinicName: clinicName,
              clinicLogo: clinicLogo,
            ),
          ),
          (route) => false,
        );
      } else {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              clinicCode: clinicCode,
              clinicName: clinicName,
              clinicLogo: clinicLogo,
            ),
          ),
          (route) => false,
        );
      }
    } else {
      final pathSegments = uri.pathSegments;

      if (pathSegments.isNotEmpty && pathSegments[0] == 'vetRegister') {
        final id = pathSegments.length > 1 ? pathSegments[1] : '';

        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => VetCareRegister(invitationCode: id),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("App is now in the background.");
      _sub?.pause();
    } else if (state == AppLifecycleState.resumed) {
      print("App is now active again.");
      _sub?.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(
          create: (context) => MainCubit()
            ..changeAppMode(fromShared: CacheHelper.getData('isDark') ?? false)
            ..changeAppLang(
                fromSharedLang: CacheHelper.getData('language') ?? 'en')
            ..saveToken()
            ..getIsAllowNotification(),
        ),
        BlocProvider(
          create: (context) => LayoutCubit()
            ..getOwnerPet()
            ..getOwnerData()
            ..getVersion()
            ..getAppVersion(),
        ),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          var cubit = MainCubit.get(context);

          return MaterialApp(
            title: 'SQueak',
            theme: buildThemeDataLight(context),
            navigatorKey: navigatorKey,
            routes: routes,
            onGenerateRoute: (settings) {
              CacheHelper.saveData('invitationCode', '');
              final uri = Uri.parse(settings.name!);

              final invitationCode =
                  uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
              CacheHelper.saveData('invitationCode', invitationCode);

              if (CacheHelper.getData('invitationCode') != '') {
                return MaterialPageRoute(
                  builder: (context) =>
                      VetCareRegister(invitationCode: invitationCode),
                );
              } else {
                return MaterialPageRoute(builder: (context) => appStartPoint);
              }
            },
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: buildThemeData(),
            debugShowCheckedModeBanner: false,
            locale: cubit.language == 'en'
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

  var appStartPoint;

  void _navigateToNextScreen() async {
    // await Future.delayed(const Duration(seconds: 1));

    final bool isForceRate = CacheHelper.getBool('IsForceRate');
    final String? token = CacheHelper.getData('token');
    final String? codeForce = CacheHelper.getData('CodeForce');
    final String? rateModelData = CacheHelper.getData('RateModel');

    if (token == null) {
      // _navigateAndReplace(LoginScreen());
      appStartPoint = LoginScreen();
    } else if (codeForce != null) {
      LayoutCubit.get(context).getOwnerPet();
      // _navigateAndReplace(
      //   PetMergeScreen(Code: codeForce, isNavigation: false),
      // );
      appStartPoint = PetMergeScreen(Code: codeForce, isNavigation: false);
    }
    // else if (isForceRate && rateModelData != null) {
    //   final AppointmentModel model =
    //   AppointmentModel.fromJson(jsonDecode(rateModelData));
    //   // _navigateAndReplace(
    //   //   RateAppointment(model: model, isNav: false),
    //   // );
    //   appStartPoint = RateAppointment(model: model, isNav: false);
    // }
    else {
      // _navigateAndReplace(LayoutScreen());
      appStartPoint = LayoutScreen();
    }
  }
}
