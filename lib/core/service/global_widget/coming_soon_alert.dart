import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class AnimatedComingSoonAlert {
  static void show(BuildContext context,) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Directionality(
          textDirection: isArabic() ? TextDirection.rtl : TextDirection.ltr,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            ),
            child: FadeTransition(
              opacity: animation,
              child: AlertDialog(
                backgroundColor:
                isDark ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Icon
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 400),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.primaryColor,
                              Colors.pink
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      isArabic() ? "الميزة قادمة قريبًا!" : "Feature Coming Soon!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? ColorManager.primaryColor
                            : ColorManager.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      isArabic()
                          ? "نحن متحمسون للإعلان أن هذه الميزة قيد التطوير وستكون متاحة قريبًا!"
                          : "We're excited to announce that this feature is in development and will be available soon!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                        isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 20),

         
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      isArabic() ? "أبلغني" : "Notify Me",
                      style: TextStyle(color: ColorManager.primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isArabic() ? "حسناً" : "OK"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
