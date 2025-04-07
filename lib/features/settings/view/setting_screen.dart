import 'package:quickalert/quickalert.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/thames/decorations.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/authentication/view/contact_us.dart';
import 'package:squeak/features/authentication/view/login_screen.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/settings/view/privacy_policy_screen.dart';
import 'package:squeak/features/settings/view/update_profile_screen.dart';
import 'package:squeak/features/settings/view//about_page.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../../../core/constant/global_function/global_function.dart';
import '../../../core/helper/cache/cache_helper.dart';
import '../../../core/helper/remotely/end-points.dart';
import '../../../core/thames/color_manager.dart';
import '../../../generated/l10n.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        return Scaffold(
          appBar: AppBar(
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
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(.0),
                    child: Row(
                      children: [
                        (state is SqueakUpdateProfilelaodingUpdated)
                            ? WidgetCircularAnimator(
                                size: 65,
                                innerIconsSize: 3,
                                outerIconsSize: 3,
                                innerAnimation: Curves.easeInOutBack,
                                outerAnimation: Curves.easeInOutBack,
                                innerColor: Colors.deepPurple,
                                outerColor: Colors.orangeAccent,
                                innerAnimationSeconds: 10,
                                outerAnimationSeconds: 10,
                                child: Container(
                                  height: 69,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                  ),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Colors.deepOrange[200],
                                    size: 30,
                                  ),
                                ),
                              )
                            : (CacheHelper.getData('ImageActive') == null)
                                ? InkWell(
                                    onTap: () {
                                      // LayoutCubit.get(context).getOwnerPet().then(
                                      //       (value) {
                                      //     cubit.addUserToProfile();
                                      //     ChangeActingPet(context, cubit);
                                      //   },
                                      // );
                                    },
                                    child: CircleAvatar(
                                      radius: 37,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      backgroundImage: NetworkImage(
                                        cubit.profile.imageName.isNotEmpty
                                            ? '$imageUrl${cubit.profile.imageName}'
                                            : AssetImageModel.defaultUserImage,
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // LayoutCubit.get(context).getOwnerPet().then(
                                      //       (value) {
                                      //     cubit.addUserToProfile();
                                      //     ChangeActingPet(context, cubit);
                                      //   },
                                      // );
                                    },
                                    child: CircleAvatar(
                                      radius: 37,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      backgroundImage: NetworkImage(CacheHelper
                                                  .getData('ImageActive') ==
                                              ''
                                          ? CacheHelper.getBool('isPet')
                                              ? AssetImageModel.defaultPetImage
                                              : AssetImageModel.defaultUserImage
                                          : '$imageUrl${CacheHelper.getData('ImageActive')}'),
                                    ),
                                  ),
                        SizedBox(
                          width: 15,
                        ),
                        (CacheHelper.getData('ImageActive') == null)
                            ? Text(
                                CacheHelper.getData('name'),
                                style: FontStyleThame.textStyle(
                                    context: context, fontSize: 18),
                              )
                            : Text(
                                CacheHelper.getData('name'),
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
                            color: ColorTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                ///personal
                Text(
                  isArabic() ? 'اعداد شخصية' : 'Personalisation',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 18,
                  ),
                ),

                /// language
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        FastCachedImage(
                          url:
                              'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(2).png?alt=media&token=a48427bd-caec-453f-8411-0101f86f97da',
                          height: 40,
                          width: 40,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic() ? 'اللغه' : 'Language',
                              style: FontStyleThame.textStyle(
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                isArabic()
                                    ? 'ضبط لغة التطبيق'
                                    : 'Set the app language',
                                style: FontStyleThame.textStyle(
                                  context: context,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        BlocConsumer<MainCubit, MainState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
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
                                      MainCubit.get(context)
                                          .changeAppLang(langMode: 'ar');
                                    },
                                    child: const Text(
                                      'اللغة العربية',
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    onTap: () {
                                      MainCubit.get(context)
                                          .changeAppLang(langMode: 'en');
                                    },
                                    child: const Text(
                                      'English language',
                                    ),
                                  ),
                                ];
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                              ),
                              offset: const Offset(0, 20),
                            );
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                /// dark mode
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        FastCachedImage(
                          url:
                              'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/Squeak__4_-removebg-preview.png?alt=media&token=eb3a7e47-fdd8-49b4-84a6-2f711c01b19d',
                          height: 40,
                          width: 40,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic() ? 'الوضع المظلم' : 'Dark mode',
                              style: FontStyleThame.textStyle(
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                isArabic()
                                    ? 'اختر وضع العرض'
                                    : 'Choose view mode',
                                style: FontStyleThame.textStyle(
                                  context: context,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        BlocConsumer<MainCubit, MainState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return Switch(
                              activeTrackColor:
                                  ColorManager.profileBaseBlueColors,
                              activeColor: ColorManager.sWhite,
                              value: MainCubit.get(context).isDark,
                              onChanged: (value) {
                                MainCubit.get(context).changeAppMode();
                              },
                            );
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                /// notifications Settings
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        FastCachedImage(
                          url:
                              'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/rb_6889.png?alt=media&token=092855b2-955e-40b6-b49f-e32f3c054560',
                          height: 40,
                          width: 40,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          isArabic() ? 'تنبيهات' : 'Notifications Alert',
                          style: FontStyleThame.textStyle(
                              context: context,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                        const Spacer(),
                        BlocConsumer<MainCubit, MainState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            var cubit = MainCubit.get(context);

                            return Switch(
                              activeTrackColor:
                                  ColorManager.profileBaseBlueColors,
                              activeColor: ColorManager.sWhite,
                              value: cubit.isAllowNotification,
                              onChanged: (value) async {
                                if (value) {
                                  await cubit.requestNotificationPermissions();
                                  cubit.saveToken();
                                } else {
                                  cubit.deleteToken();
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                ///personal
                Text(
                  isArabic() ? 'اخري' : 'Other',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 18,
                  ),
                ),

                /// frindly mode
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Share.share("http://veticareapp.com/share");
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          FastCachedImage(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/image-removebg-preview%20(3).png?alt=media&token=fa1e78d4-1c01-4c15-8420-6d78a51bbf3f',
                            height: 40,
                            width: 40,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic() ? 'مشاركة التطبيق' : 'Share App',
                                style: FontStyleThame.textStyle(
                                    context: context,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  isArabic()
                                      ? "ساعدنا في مشاركة التطبيق"
                                      : 'Help us to share the app',
                                  style: FontStyleThame.textStyle(
                                    context: context,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(Icons.share),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Contact Us
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        navigateToScreen(context, ContactScreen());
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          FastCachedImage(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/blue_email_with_bell_notification_icon_3d_background_illustration-removebg-preview.png?alt=media&token=50af2f5f-5cfe-4caf-b1b2-5914ce3c75bb',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic() ? 'اتصل بنا' : 'Contact Us',
                                style: FontStyleThame.textStyle(
                                    context: context,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  isArabic()
                                      ? 'تواصل معانا في حالة حدوث اي مشكلة'
                                      : 'Contact us in case of any problem',
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
                          ),
                          const Spacer(),
                          Icon(Icons.help_outline),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        navigateToScreen(context, PrivacyPolicyScreen());
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          FastCachedImage(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/intellectual-property-concept.png?alt=media&token=e9e8c640-ebe1-43b2-af20-376c5b570878',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            isArabic() ? 'سياسة الخصوصية' : 'Privacy Policy',
                            style: FontStyleThame.textStyle(
                                context: context,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          const Spacer(),
                          Icon(Icons.privacy_tip_outlined),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // About
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          FastCachedImage(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/information.png?alt=media&token=4fd9b59f-8399-4bc9-b48e-1095b7152b03',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            isArabic() ? 'عن' : 'About',
                            style: FontStyleThame.textStyle(
                                context: context,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          const Spacer(),
                          Icon(Icons.info_outline),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 25,
                ),

                ///personal
                Text(
                  isArabic() ? 'تسجيل خروج' : 'Logout',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 18,
                  ),
                ),

                /// logout
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 69,
                  decoration:
                      Decorations.kDecorationBoxShadow(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        QuickAlert.show(
                          context: context,
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.white,
                          type: QuickAlertType.confirm,
                          textColor: !MainCubit.get(context).isDark
                              ? Colors.black
                              : Colors.white,
                          titleColor: !MainCubit.get(context).isDark
                              ? Colors.black
                              : Colors.white,
                          title: isArabic() ? 'تسجيل خروج' : 'Logout',
                          cancelBtnText: isArabic() ? 'لا' : 'No',
                          confirmBtnText: isArabic() ? 'نعم' : 'Yes',
                          text: isArabic()
                              ? 'هل تريد تسجيل الخروج؟'
                              : 'Do you want to log out?',
                          showConfirmBtn: true,
                          onCancelBtnTap: () {
                            Navigator.pop(context);
                          },
                          onConfirmBtnTap: () {
                            MainCubit.get(context).removeToken();
                            LayoutCubit.get(context).changeBottomNav(0);
                            CacheHelper.clearData();

                            navigateAndFinish(context, LoginScreen());
                          },
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          FastCachedImage(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/3599716.webp?alt=media&token=24213687-4927-4ab2-8d74-ecf2e23fe4d3',
                            height: 40,
                            width: 40,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic() ? 'تسجيل خروج' : 'Logout',
                                style: FontStyleThame.textStyle(
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(IconlyLight.logout),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
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
}
