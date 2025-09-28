import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class ProfileSwitchNotificationScreen extends StatelessWidget {
  const ProfileSwitchNotificationScreen({super.key});

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
              // top icon with paw + sparkles
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ColorManager.primaryColor, Colors.pink],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      IconlyBold.heart,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: _AnimatedIcon(
                      icon: Icons.pets,
                      color: ColorManager.primaryColor.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    bottom: -6,
                    left: -6,
                    child: _AnimatedIcon(
                      icon: IconlyBold.star,
                      color: Colors.pink.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // title
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

              // description
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

              // alert box
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

/// bouncing small icons
class _AnimatedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _AnimatedIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 8.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -value),
          child: Icon(icon, size: 20, color: color),
        );
      },
      onEnd: () {},
    );
  }
}
