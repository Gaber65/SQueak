// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/features/profile_switch/Presentation/widget/screens/profile_switcher_page.dart';
import 'package:squeak/features/settings/persentaion/controller/setting_cubit.dart';

bool hasPlayedProfileAnimation = false;

class ProfileSwitchNotificationScreen extends StatefulWidget {
  const ProfileSwitchNotificationScreen({super.key});

  @override
  State<ProfileSwitchNotificationScreen> createState() =>
      _ProfileSwitchNotificationScreenState();
}

class _ProfileSwitchNotificationScreenState
    extends State<ProfileSwitchNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Directionality(
        textDirection: isArabic() ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                isDark ? const Color(0xFF1E1E1E) : Colors.white,
                isDark ? const Color(0xFF232323) : Colors.grey.shade100,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.primaryColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => sl<PetCubit>()..getOwnerPets(),
                      lazy: false,
                    ),
                    BlocProvider(
                      create: (_) => sl<SettingCubit>()..getOwnerData(),
                      lazy: true,
                    ),
                    BlocProvider(
                      create: (_) => sl<SwitchProfileCubit>()..loadProfile(),
                      lazy: true,
                    ),
                  ],
                  child: BlocConsumer<SwitchProfileCubit, SwitchProfileState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      var cubit = SwitchProfileCubit.get(context);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Profile button container
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade200,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.primaryColor
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: _StaticProfileButton(
                                  isDark: isDark,
                                  image: cubit.image,
                                  name: cubit.name,
                                ),
                              ),

                              // Swap icon positioned at bottom center
                              Positioned(
                                bottom: -8, // move slightly below the circle
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorManager.primaryColor
                                            .withOpacity(0.3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.swap_horiz,
                                    color: ColorManager.primaryColor,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      colors: [ColorManager.primaryColor, Colors.pink],
                    ).createShader(bounds),
                child: Text(
                  isArabic()
                      ? "ميزة صداقة اصدقائك الصغار"
                      : "Pet Friendship Feature",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                isArabic()
                    ? "اربط  الأليف مع أصدقاء آخرين في منطقتك وابنِ صداقات تدوم."
                    : "Connect your furry friends with other pets in your area and build lasting friendships.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primaryColor.withOpacity(0.05),
                      Colors.pink.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: ColorManager.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [ColorManager.primaryColor, Colors.pink],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        IconlyBold.user_2,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic()
                                ? "مطلوب التحويل إلى   الأليف"
                                : "Profile Switch Required",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic()
                                ? "لفتح ميزة صداقة  الأليفة، قم بالتحويل إلى ملف  الأليف. هذا يساعد الآخرين في اكتشاف  الأليف."
                                : "To unlock the pet friendship feature, switch to your pet profile. This lets other pet parents discover your furry friend.",
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Static Profile Button (no animation)
class _StaticProfileButton extends StatelessWidget {
  final bool isDark;
  final String? image;
  final String? name;

  const _StaticProfileButton({
    required this.isDark,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = SwitchProfileCubit.get(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 2,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ProfileSwitcherButton(
        width: 80,
        height: 80,
        image: cubit.image,
        name: cubit.name,
      ),
    );
  }
}
