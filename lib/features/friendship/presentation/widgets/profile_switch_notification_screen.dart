import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/features/profile_switch/Presentation/widget/screens/profile_switcher_page.dart';

bool hasPlayedProfileAnimation = false;

class ProfileSwitchNotificationScreen extends StatefulWidget {
  const ProfileSwitchNotificationScreen({super.key});

  @override
  State<ProfileSwitchNotificationScreen> createState() =>
      _ProfileSwitchNotificationScreenState();
}

class _ProfileSwitchNotificationScreenState
    extends State<ProfileSwitchNotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  bool _isAnimationStopped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleProfileButtonTap() {
    if (!_isAnimationStopped) {
      setState(() {
        _isAnimationStopped = true;
      });
      _animationController.stop();
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

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
                child: BlocConsumer<SwitchProfileCubit, SwitchProfileState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    var cubit = SwitchProfileCubit.get(context);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          ColorManager.primaryColor.withOpacity(
                                            0.3,
                                          ),
                                          ColorManager.primaryColor.withOpacity(
                                            0.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: GestureDetector(
                                    onTap: _handleProfileButtonTap,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorManager.primaryColor,
                                          width: 3,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorManager.primaryColor
                                                .withOpacity(0.5),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: AbsorbPointer(
                                        absorbing: false,
                                        child: _StaticProfileButton(
                                          isDark: isDark,
                                          image: cubit.image,
                                          name: cubit.name,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -8,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      -5 * (_scaleAnimation.value - 1),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            ColorManager.primaryColor,
                                            Colors.pink,
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorManager.primaryColor
                                                .withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.swap_horiz,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        // "Tap to Switch" indicator
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: 0.5 + (_scaleAnimation.value - 1) * 5,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.touch_app,
                                    size: 16,
                                    color: ColorManager.primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isArabic()
                                        ? "اضغط للتبديل"
                                        : "Tap to Switch",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: ColorManager.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
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
