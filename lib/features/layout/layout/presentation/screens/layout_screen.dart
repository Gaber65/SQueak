import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/theme/app_theme.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
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


        // Check for version updates when both version states are successful
        if (state is GetVersionSuccessState ||
            state is GetCurrentVersionSuccessState) {
          final cubit = context.read<LayoutCubit>();
          if (!_isDialogShown &&
              cubit.versionEntity != null &&
              cubit.currentVersion.isNotEmpty) {


            String serverVersion = cubit.versionEntity!.version; // "1.0.25"
            String currentVersion = cubit.currentVersion;        // "1.0.26"

            if (isVersionGreater(serverVersion, currentVersion)) {
              print("يوجد تحديث");
              if (cubit.versionEntity!.version != cubit.currentVersion) {
                _isDialogShown = true;
                await showUpdateDialog(
                  context,
                  cubit.versionEntity!,
                ).whenComplete(() {
                  _isDialogShown = false;
                });
              }
            } else {
              print("أحدث نسخة بالفعل");
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
          body: cubit.screens[selectedIndex],
          floatingActionButton: SizedBox(
            width: 64,
            height: 64,
            child: BlocConsumer<MainCubit, MainState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return FloatingActionButton(
                  onPressed: () {
                    navigateToScreen(context, const PetScreen());
                  },
                  child: const Icon(Icons.pets, size: 28),
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
              final theme = Theme.of(context);
              return AnimatedBottomNavigationBar(
                activeColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surface,
                inactiveColor: theme.colorScheme.onSurfaceVariant,
                splashSpeedInMilliseconds: 200,
                gapWidth: 88,
                activeIndex: selectedIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);
                  setState(() {
                    selectedIndex = index;
                  });
                },
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.softEdge,
                icons: const [
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
