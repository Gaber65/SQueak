import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../../../auth/contactus/presentation/pages/contact_us.dart';
import '../../../auth/login/presentation/pages/login_screen.dart';
import '../../../settings/persentaion/view/privacy_policy_screen.dart';
import '../../../settings/persentaion/view/update_profile_screen.dart';
import '../controller/setting_cubit.dart';
import 'about_page.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingCubit>()..getOwnerData(),
      child: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(S.of(context).settings),
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ///image + name + change
                  Container(
                    height: 69,
                    decoration: Decorations.kDecorationBoxShadow(
                      context: context,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(.0),
                      child: Row(
                        children: [
                          buildImage(context),
                          SizedBox(width: 15),
                          Text(
                            CacheHelper.getData('name') ?? '',
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              navigateToScreen(context, UpProfileScreen());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  // Text(
                  //   S.of(context).managePets,
                  //   style: FontStyleThame.textStyle(
                  //     context: context,
                  //     fontSize: 18,
                  //   ),
                  // ),
                  // SizedBox(height: 12),

                  // // MatingLayout pet  Section
                  // _buildSettingItem(
                  //   context: context,
                  //   icon:
                  //       'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/rb_49299.png?alt=media&token=3f7daec5-e664-43bc-9e62-0ef2b7f018f3',
                  //   title: S.of(context).matingShows,
                  //   subtitle: '',
                  //   trailingWidget: IconButton(
                  //     onPressed: () {
                  //       navigateToScreen(context, ProfileComplete());
                  //     },
                  //     icon: Icon(Icons.chevron_right),
                  //   ),
                  // ),
                  // SizedBox(height: 12),
                  // _buildSettingItem(
                  //   context: context,
                  //   icon:
                  //       '',
                  //   title: S.of(context).blockedPets,
                  //   subtitle: '',
                  //   onTap: () {
                  //     navigateToScreen(context, const BlockedPetsScreen());
                  //   },
                  //   trailingWidget: IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.block),
                  //   ),
                  // ),
                  SizedBox(height: 12),
                  // Personalization Section
                  Text(
                    S.of(context).personalization,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Language Settings
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(2).png?alt=media&token=a48427bd-caec-453f-8411-0101f86f97da',
                    title: S.of(context).personalization,
                    subtitle: S.of(context).setLanguage,
                    trailingWidget: BlocConsumer<MainCubit, MainState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return PopupMenuButton<int>(
                          onCanceled: () {
                            Navigator.of(context);
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 1,
                                onTap: () {
                                  MainCubit.get(
                                    context,
                                  ).changeAppLang(langMode: 'ar');
                                },
                                child: const Text('اللغة العربية'),
                              ),
                              PopupMenuItem(
                                value: 2,
                                onTap: () {
                                  MainCubit.get(
                                    context,
                                  ).changeAppLang(langMode: 'en');
                                },
                                child: const Text('English language'),
                              ),
                            ];
                          },
                          icon: const Icon(Icons.chevron_right),
                          offset: const Offset(0, 20),
                        );
                      },
                    ),
                  ),
                  // Dark Mode
                  SizedBox(height: 12),
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/Squeak__4_-removebg-preview.png?alt=media&token=eb3a7e47-fdd8-49b4-84a6-2f711c01b19d',
                    title: S.of(context).darkMode,
                    subtitle: S.of(context).chooseViewMode,
                    trailingWidget: BlocConsumer<MainCubit, MainState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return Switch(
                          activeTrackColor: ColorManager.profileBaseBlueColors,
                          activeColor: ColorManager.sWhite,
                          value: MainCubit.get(context).isDark,
                          onChanged: (value) {
                            MainCubit.get(context).changeAppMode();
                          },
                        );
                      },
                    ),
                  ),

                  // Notification Settings
                  SizedBox(height: 25),
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/rb_6889.png?alt=media&token=092855b2-955e-40b6-b49f-e32f3c054560',
                    title: S.of(context).notifications,
                    subtitle: '',
                    trailingWidget: BlocConsumer<MainCubit, MainState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        var cubit = MainCubit.get(context);
                        return Switch(
                          activeTrackColor: ColorManager.profileBaseBlueColors,
                          activeColor: ColorManager.sWhite,
                          value: cubit.isNotificationEnabled,
                          onChanged: (value) async {
                            if (value) {
                              await cubit.requestNotificationPermissions();
                              await cubit.saveToken(); // Optional
                            } else {
                              await cubit.deleteToken();
                            }
                          },
                        );
                      },
                    ),
                  ),

                  // Other section
                  SizedBox(height: 25),
                  Text(
                    S.of(context).other,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Share App
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(3).png?alt=media&token=fa1e78d4-1c01-4c15-8420-6d78a51bbf3f',
                    title: S.of(context).shareApp,
                    subtitle: S.of(context).helpShare,
                    onTap: () {
                      Share.share("http://veticareapp.com/share");
                    },
                    trailingWidget: Icon(Icons.share),
                  ),

                  // Contact Us
                  SizedBox(height: 12),
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/blue_email_with_bell_notification_icon_3d_background_illustration-removebg-preview.png?alt=media&token=50af2f5f-5cfe-4caf-b1b2-5914ce3c75bb',
                    title: S.of(context).contactUs,
                    subtitle: S.of(context).contactProblem,
                    onTap: () {
                      navigateToScreen(context, ContactScreen());
                    },
                    trailingWidget: Icon(Icons.help_outline),
                  ),

                  // Privacy Policy
                  SizedBox(height: 12),
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/intellectual-property-concept.png?alt=media&token=e9e8c640-ebe1-43b2-af20-376c5b570878',
                    title: S.of(context).privacyPolicy,
                    subtitle: '',
                    onTap: () {
                      navigateToScreen(context, PrivacyPolicyScreen());
                    },
                    trailingWidget: Icon(Icons.privacy_tip_outlined),
                  ),

                  // About
                  SizedBox(height: 12),
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/information.png?alt=media&token=4fd9b59f-8399-4bc9-b48e-1095b7152b03',
                    title: S.of(context).about,
                    subtitle: '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                    trailingWidget: Icon(Icons.info_outline),
                  ),

                  // Logout section
                  SizedBox(height: 25),
                  Text(
                    S.of(context).logout,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Logout
                  _buildSettingItem(
                    context: context,
                    icon:
                        'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/3599716.webp?alt=media&token=24213687-4927-4ab2-8d74-ecf2e23fe4d3',
                    title: S.of(context).logout,
                    subtitle: '',
                    onTap: () {
                      QuickAlert.show(
                        context: context,
                        backgroundColor:
                            MainCubit.get(context).isDark
                                ? ColorManager.myPetsBaseBlackColor
                                : Colors.white,
                        type: QuickAlertType.confirm,
                        textColor:
                            !MainCubit.get(context).isDark
                                ? Colors.black
                                : Colors.white,
                        titleColor:
                            !MainCubit.get(context).isDark
                                ? Colors.black
                                : Colors.white,
                        title: S.of(context).logout,
                        cancelBtnText: S.of(context).no,
                        confirmBtnText: S.of(context).yes,
                        text: S.of(context).logoutConfirm,
                        showConfirmBtn: true,
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                        onConfirmBtnTap: () async {
                          debugPrint(
                            '[Logout] Confirm tapped - starting logout sequence',
                          );
                          // First remove token from backend/service then clear local data and reset state
                          debugPrint(
                            '[Logout] Calling MainCubit.removeToken()',
                          );
                          await MainCubit.get(context).removeToken();
                          if (!context.mounted) return;
                          LayoutCubit.get(context).changeBottomNav(0);

                          // Clear local cache first to avoid race conditions with newly created LoginScreen
                          debugPrint('[Logout] Clearing CacheHelper data');
                          await CacheHelper.clearData();

                          // Reset MainCubit state before navigating
                          debugPrint('[Logout] Resetting MainCubit state');
                          if (!context.mounted) return;
                          MainCubit.get(context).resetState();

                          // Finally navigate to LoginScreen and clear navigation stack
                          debugPrint('[Logout] Navigating to LoginScreen');
                          navigateAndFinish(context, LoginScreen());
                        },
                      );
                    },
                    trailingWidget: Icon(IconlyLight.logout),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    final profile = SettingCubit.get(context).profile;
    final imageActive = CacheHelper.getData('ImageActive');
    final isPet = CacheHelper.getBool('isPet');

    ImageProvider backgroundImage;

    if (imageActive != null && imageActive != '') {
      backgroundImage = NetworkImage('$imageUrl$imageActive');
    } else if (profile != null && profile.imageName != '') {
      backgroundImage = NetworkImage('$imageUrl${profile.imageName}');
    } else {
      backgroundImage = NetworkImage(
        isPet
            ? AssetImageModel.defaultPetImage
            : AssetImageModel.defaultUserImage,
      );
    }

    return CircleAvatar(
      radius: 33,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundImage: backgroundImage,
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 69,
      decoration: Decorations.kDecorationBoxShadow(context: context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SizedBox(width: 10),
              FastCachedImage(
                url: icon,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              trailingWidget ?? SizedBox(),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
