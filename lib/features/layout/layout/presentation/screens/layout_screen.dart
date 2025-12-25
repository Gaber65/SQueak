import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:squeak/features/layout/notification/NotificationAPI/presentation/widget/navigate_based_on_notification.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../../pets/presentation/controller/pet_cubit.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_cubit.dart';
import '../../../../settings/persentaion/controller/setting_cubit.dart';
import '../widgets/update_dialog.dart';

class LayoutScreen extends StatefulWidget {
  final bool showPostCreatedSnackbar;

  const LayoutScreen({super.key, this.showPostCreatedSnackbar = false});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  bool _isDialogShown = false;
  int selectedIndex = 0;

  late AnimationController _jumpController;

  @override
  initState() {
    super.initState();

    if (widget.showPostCreatedSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Post created successfully!',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'تم إنشاء المنشور بنجاح!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              duration: const Duration(seconds: 3),
              elevation: 6,
            ),
          );
        });
      });
    }

    MainCubit.get(context).saveToken();
    MainCubit.get(
      context,
    ).setLangInAPI(CacheHelper.getData('language') == 'ar' ? 1 : 0);

    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    if (CacheHelper.getData('havePets') == '[]' ||
        CacheHelper.getData('havePets') == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _jumpController.forward();
      });
    }

    getNotificationAppLaunchDetails();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialNotificationPayload != null) {
        final entity = payloadToNotificationEntity(initialNotificationPayload!);

        // reset
        initialNotificationPayload = null;
        return navigateBasedOnNotification(entity, context);
      }
    });
  }

  Future<void> getNotificationAppLaunchDetails() async {
    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      initialNotificationPayload = details!.notificationResponse?.payload;
    }
  }

  @override
  void dispose() {
    flutterLocalNotificationsPlugin.cancelAll();
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(create: (_) => sl<SettingCubit>()..getOwnerData()),
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),
        BlocProvider(
          create:
              (context) =>
                  sl<LayoutCubit>()
                    ..getAppVersion()
                    ..getVersion(),
        ),
      ],
      child: BlocConsumer<LayoutCubit, LayoutState>(
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
          return BlocBuilder<SwitchProfileCubit, SwitchProfileState>(
            builder: (context, profileState) {
              final activeProfile =
                  context.read<SwitchProfileCubit>().activeProfile;
              final isPetProfile = activeProfile?.type == ProfileType.pet;

              final petIcons = [
                IconlyBold.home,
                Icons.explore_outlined,
                Icons.favorite_border,
                Icons.chat_bubble_outline,
                Icons.pets,
              ];

              final ownerIcons = [
                IconlyBold.home,
                FontAwesomeIcons.bone,
                Icons.pets_outlined,
                IconlyBold.time_circle,
                IconlyBold.setting,
              ];

              final icons = isPetProfile ? petIcons : ownerIcons;

              final petLabelsEN = [
                'Home',
                'Browse',
                'Requests',
                'Chats',
                'Profile',
              ];

              final petLabelsAR = [
                'الرئيسية',
                'استكشاف',
                'الطلبات',
                'الرسائل',
                'الملف الشخصي',
              ];

              final ownerLabelsEN = [
                'Home',
                'Friends',
                'Pets',
                'Care',
                'Settings',
              ];

              final ownerLabelsAR = [
                'الرئيسية',
                'الأصدقاء',
                'الصغار',
                'العناية',
                'الإعدادات',
              ];

              final labelsEN = isPetProfile ? petLabelsEN : ownerLabelsEN;
              final labelsAR = isPetProfile ? petLabelsAR : ownerLabelsAR;

              return Scaffold(
                extendBody: false,
                resizeToAvoidBottomInset: false,
                body:
                    isPetProfile
                        ? cubit
                            .screensPets[selectedIndex] 
                        : cubit.screens[selectedIndex], 
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
                                      : Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            Flexible(
                              child: Text(
                                isArabic() ? labelsAR[index] : labelsEN[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isActive
                                          ? ColorManager.primaryColor
                                          : Colors.grey,
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
        },
      ),
    );
  }
}
