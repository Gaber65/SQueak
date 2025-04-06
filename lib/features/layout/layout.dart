import 'dart:async';
import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/models/version_model.dart';
import 'package:squeak/features/pets/view/pet_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../authentication/view/login_screen.dart';
import 'controller/layout_cubit.dart';

Completer<bool> completer = Completer<bool>();

const String versionPlatForm = '1';
Future<bool> showExitConfirmationDialog(BuildContext context) async {
  // Use Completer to return a value asynchronously.
  completer = Completer<bool>();
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    backgroundColor:
        MainCubit.get(context).isDark
            ? ColorManager.myPetsBaseBlackColor
            : Colors.white,
    textColor: MainCubit.get(context).isDark ? Colors.white : Colors.black,
    titleColor: MainCubit.get(context).isDark ? Colors.white : Colors.black,
    title: isArabic() ? 'إغلاق التطبيق' : 'Close App',
    cancelBtnText: isArabic() ? 'لا' : 'No',
    confirmBtnText: isArabic() ? 'نعم' : 'Yes',
    text:
        isArabic()
            ? 'هل أنت متأكد من إغلاق التطبيق؟'
            : 'Are you sure you want to close the app?',
    showCancelBtn: true,
    onCancelBtnTap: () {
      Navigator.of(context).pop(); // Close the alert.
      completer.complete(false); // User canceled.
    },
    onConfirmBtnTap: () {
      Navigator.of(context).pop(); // Close the dialog
      // Exit the app on confirmation
      if (Platform.isAndroid) {
        SystemNavigator.pop(); // Exit app on Android
      } else if (Platform.isIOS) {
        exit(0); // Force exit on iOS (use with caution)
      }
      completer.complete(true);
    },
  );

  return completer.future; // Wait for the user's decision.
}

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    MainCubit.get(context).saveToken();
    MainCubit.get(
      context,
    ).setLangInAPI(CacheHelper.getData('language') == 'ar' ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              LayoutCubit()
                ..getOwnerPet()
                ..getOwnerData()
                ..getVersion()
                ..getAppVersion(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) async {
          if (CacheHelper.getBool('isExpiredToken')) {
            await buildShowDialogExpierToken(context).whenComplete(() {
              CacheHelper.clearData();
              navigateAndFinish(context, const LoginScreen());
            });
          }
          if (LayoutCubit.get(context).getVersionFromBackLoading == false) {
            print("@@@@@@@@@@@@@@");
            print(LayoutCubit.get(context).version!.data.version);
            print(LayoutCubit.get(context).currentVersion);
            if (!_isDialogShown) {
              if (LayoutCubit.get(context).version != null) {
                if (LayoutCubit.get(context).version!.data.version !=
                    LayoutCubit.get(context).currentVersion) {
                  _isDialogShown = true;
                  await buildShowDialogUpdate(
                    context,
                    LayoutCubit.get(context).version!,
                  ).whenComplete(() {
                    _isDialogShown = false;
                  });
                }
              }
            }
          }
        },
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);

          return Scaffold(
            extendBody: false,
            resizeToAvoidBottomInset: false,
            body: PopScope(
              canPop: false,
              onPopInvokedWithResult:
                  (didPop, result) => showExitConfirmationDialog(context),
              child: cubit.screens[cubit.selectedIndex],
            ),
            floatingActionButton: SizedBox(
              width: 70, // Set the width as desired
              height: 70, // Set the height as desired
              child: BlocConsumer<MainCubit, MainState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return FloatingActionButton(
                    backgroundColor:
                        MainCubit.get(context).isDark
                            ? ThemeData.dark().scaffoldBackgroundColor
                            : Colors.white,
                    foregroundColor: ColorManager.primaryColor,
                    onPressed: () {
                      navigateToScreen(context, PetScreen());
                    },
                    child: Icon(Icons.pets, size: 30),
                  );
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BlocConsumer<MainCubit, MainState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return AnimatedBottomNavigationBar(
                  activeColor: ColorManager.primaryColor,
                  backgroundColor:
                      MainCubit.get(context).isDark
                          ? ThemeData.dark().scaffoldBackgroundColor
                          : Colors.white,
                  inactiveColor: Colors.grey,
                  splashSpeedInMilliseconds: 300,
                  gapWidth: 100,
                  activeIndex: cubit.selectedIndex,
                  onTap: (index) {
                    cubit.changeBottomNav(index);
                  },
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.softEdge,
                  icons: [
                    IconlyLight.home,
                    IconlyLight.add_user,
                    IconlyLight.time_circle,
                    IconlyLight.setting,
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> buildShowDialogExpierToken(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    isArabic() ? 'انتهت صلاحية الجلسة' : 'Session Expired',
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontColor: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      CacheHelper.clearData();
                      navigateAndFinish(context, const LoginScreen());
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.red.shade400,
                      size: 50,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic()
                              ? 'انتهت صلاحية الجلسة'
                              : 'Your session has expired',
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          isArabic()
                              ? 'سيتم تحويلك لصفحة تسجيل الدخول'
                              : 'You will be redirected to login page',
                          maxLines: 2,
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        CacheHelper.clearData();
                        navigateAndFinish(context, const LoginScreen());
                      },
                      child: Text(isArabic() ? "موافق" : "OK"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> buildShowDialogUpdate(
    BuildContext context,
    VerSionModel model,
  ) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.network(
                'https://lottie.host/5ebf2bcb-cdc1-40f0-a424-1f4bcf39ea89/IcNnV7PZPk.json',
                height: 200,
                width: 400,
                repeat: true,
              ),
              SizedBox(height: 10),
              Text(
                S.of(context).updateVersionModuleContent,
                maxLines: 2,
                style: FontStyleThame.textStyle(
                  context: context,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 10),
              Text(
                S.of(context).updateVersionModuleContent2,
                maxLines: 2,
                style: FontStyleThame.textStyle(
                  context: context,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              if (model.data.forceUpdate)
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => launchUrl(Uri.parse(model.data.link)),
                    child: Text(
                      S.of(context).updateVersionModuleButtonUpdateNow,
                    ),
                  ),
                ),
              if (!model.data.forceUpdate)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            S.of(context).updateVersionModuleButtonIgnore,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            print("new update");
                            final String iosLink =
                                "https://apps.apple.com/us/app/squeak-pets/id6739161083";
                            final String androidLink =
                                "https://play.google.com/store/apps/details?id=com.softicare.squeak&hl=en&pli=1";
                            debugPrint("Running on: $iosLink");
                            debugPrint("Opening URL: $androidLink");
                            final Uri url = Uri.parse(
                              Platform.isIOS ? iosLink : androidLink,
                            );

                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                              // Print mobile type and URL
                            } else {
                              debugPrint("Could not launch $url");
                            }
                          },
                          child: Text(
                            S.of(context).updateVersionModuleButtonUpdateNow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      if (model.data.forceUpdate) {
        launchUrl(Uri.parse(model.data.link));
      }
    });
  }
}
