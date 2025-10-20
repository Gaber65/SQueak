
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';
import 'package:squeak/features/profile_switch/Presentation/widget/screens/profile_switcher_page.dart';

bool hasPlayedProfileAnimation = false;

class ProfileSwitchMatingNotificationScreen extends StatefulWidget {
  const ProfileSwitchMatingNotificationScreen({super.key});

  @override
  State<ProfileSwitchMatingNotificationScreen> createState() =>
      _ProfileSwitchMatingNotificationScreenState();
}

class _ProfileSwitchMatingNotificationScreenState
    extends State<ProfileSwitchMatingNotificationScreen> {
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
                        Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Profile button container
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDark
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

                            // Heart icon positioned at bottom center
                            Positioned(
                              bottom: -8, // move slightly below the circle
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pink.withOpacity(0.3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.switch_access_shortcut,
                                  color: Colors.pink,
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
              const SizedBox(height: 16),

              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.pink, ColorManager.primaryColor],
                ).createShader(bounds),
                child: Text(
                  isArabic()
                      ? "ميزة التزاوج للحيوانات الأليفة"
                      : "Pet Mating Feature",
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
                    ? "ابحث عن شريك مثالي لحيوانك الأليف وادعم استمرار السلالة بطريقة مسؤولة."
                    : "Find the perfect mate for your pet and support responsible breeding practices.",
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
                      Colors.pink.withOpacity(0.05),
                      ColorManager.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.pink.withOpacity(0.3),
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
                          colors: [Colors.pink, ColorManager.primaryColor],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        IconlyBold.heart,
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
                                ? "مطلوب التحويل إلى الحيوان الأليف"
                                : "Profile Switch Required",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic()
                                ? "لفتح ميزة التزاوج للحيوانات الأليفة، قم بالتحويل إلى ملف الحيوان الأليف. هذا يساعد في العثور على الشريك المناسب بناءً على معايير التزاوج."
                                : "To unlock the pet mating feature, switch to your pet profile. This helps find suitable mates based on breeding criteria and characteristics.",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
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

/// Static Profile Button (no animation) - Same as original
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