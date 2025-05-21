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
import 'package:squeak/features/authentication/view/login_screen.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubit/layout_cubit.dart';
import '../../domain/entities/version_entity.dart';
import '../widgets/exit_confirmation_dialog.dart';
import '../widgets/expired_token_dialog.dart';
import '../widgets/update_dialog.dart';

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

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) async {
        if (CacheHelper.getBool('isExpiredToken')) {
          await showExpiredTokenDialog(context).whenComplete(() {
            CacheHelper.clearData();
            navigateAndFinish(context, const LoginScreen());
          });
        }

        // Check for version updates when both version states are successful
        if (state is GetVersionSuccessState ||
            state is GetCurrentVersionSuccessState) {
          final cubit = context.read<LayoutCubit>();
          if (!_isDialogShown &&
              cubit.versionEntity != null &&
              cubit.currentVersion.isNotEmpty) {
            if (cubit.versionEntity!.version != cubit.currentVersion) {
              _isDialogShown = true;
              await showUpdateDialog(
                context,
                cubit.versionEntity!,
              ).whenComplete(() {
                _isDialogShown = false;
              });
            }
          }
        }
      },
      builder: (context, state) {
        final cubit = LayoutCubit.get(context);
        selectedIndex = cubit.selectedIndex;
        return Scaffold(
          extendBody: false,
          resizeToAvoidBottomInset: false,
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult:
                (didPop, result) => showExitConfirmationDialog(context),
            child: cubit.screens[selectedIndex],
          ),
          floatingActionButton: SizedBox(
            width: 70,
            height: 70,
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
                activeIndex: selectedIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);
                  setState(() {
                    selectedIndex = index;
                  });
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
    );
  }
}
