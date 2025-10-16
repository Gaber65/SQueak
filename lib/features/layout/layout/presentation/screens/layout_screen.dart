import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/update_dialog.dart';



class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  bool _isDialogShown = false;
  int selectedIndex = 0;

  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;

  @override
  void initState() {
    // print(CacheHelper.getData('havePets'));
    super.initState();

    MainCubit.get(context).saveToken();
    MainCubit.get(
      context,
    ).setLangInAPI(CacheHelper.getData('language') == 'ar' ? 1 : 0);

    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    _jumpAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -10,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -8,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -6,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 7,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -6,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 7,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -4,
          end: 0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 4,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -2,
          end: 0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 4,
      ),
    ]).animate(_jumpController);

    if (CacheHelper.getData('havePets') == '[]' ||
        CacheHelper.getData('havePets') == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _jumpController.forward();
      });
    }
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) async {
        if (state is GetVersionSuccessState ||
            state is GetCurrentVersionSuccessState) {
          final cubit = context.read<LayoutCubit>();
          if (!_isDialogShown &&
              cubit.versionEntity != null &&
              cubit.currentVersion.isNotEmpty) {
            String serverVersion = cubit.versionEntity!.version;
            String currentVersion = cubit.currentVersion;

            if (isVersionGreater(serverVersion, currentVersion)) {
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
        }
      },
      builder: (context, state) {
        final cubit = LayoutCubit.get(context);
        selectedIndex = cubit.selectedIndex;

        final icons = [
          IconlyBold.home,
          FontAwesomeIcons.bone,
          Icons.pets_outlined,
          IconlyBold.time_circle,
          IconlyBold.setting,
        ];

        return Scaffold(
          extendBody: false,
          resizeToAvoidBottomInset: false,

          body: cubit.screens[selectedIndex] ,

          bottomNavigationBar: BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {},
            builder: (context, state) {
              final theme = Theme.of(context);
              return AnimatedBottomNavigationBar.builder(
                itemCount: icons.length,
                gapLocation: GapLocation.none,
                notchSmoothness: NotchSmoothness.softEdge,
                backgroundColor: theme.colorScheme.surface,
                activeIndex: selectedIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);
                  setState(() {
                    selectedIndex = index;
                  });
                },
                tabBuilder: (int index, bool isActive) {
                  final icon = icons[index];
                  final labelsEN = [
                    'Home',
                    'Friends',
                    'Pets',
                    'Care',
                    'Settings',
                  ];
                  final labelsAR = [
                    'الرئيسية',
                    'الأصدقاء',
                    'الصفار',
                    'العناية',
                    'الإعدادات',
                  ];


                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          icon,
                          size: isActive ? 30 : 26,
                          color:
                          isActive
                              ? ColorManager.primaryColor
                              : Colors.grey
                      ),
                      const SizedBox(height: 2),
                      Flexible(
                        child: Text(
                         isArabic() ? labelsAR[index] : labelsEN[index] ,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                            isActive
                                ? ColorManager.primaryColor
                                : Colors.grey
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
