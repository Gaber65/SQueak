import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddPetPressed;

  const EmptyState({
    super.key,
    required this.onAddPetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MainCubit.get(context).isDark 
                ? const Color(0xFF121212) 
                : const Color(0xFFF8FAFC),
            MainCubit.get(context).isDark 
                ? Colors.grey[900]!.withOpacity(0.8)
                : Colors.grey[50]!.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorManager.primaryColor.withOpacity(0.1),
                      ColorManager.secondColor.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: ColorManager.primaryColor.withOpacity(0.2),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(77),
                  child: FastCachedImage(
                    url: 'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/happy-pets-animal-ai-art-388_720x.webp?alt=media&token=eee507ff-48c5-450d-88d9-4203537ed79b',
                    fit: BoxFit.cover,
                    errorBuilder: (context, exception, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.primaryColor.withOpacity(0.3),
                              ColorManager.secondColor.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 80,
                          color: Colors.white,
                        ),
                      );
                    },
                    loadingBuilder: (context, progress) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.primaryColor.withOpacity(0.1),
                              ColorManager.secondColor.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorManager.primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                S.of(context).noPetsFound,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: MainCubit.get(context).isDark ? Colors.white : Colors.black87,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isArabic()
                    ? "ابدأ رحلة العناية بحيوانك الأليف"
                    : "Start your pet care journey",
                style: TextStyle(
                  fontSize: 16,
                  color: MainCubit.get(context).isDark 
                      ? Colors.grey[400] 
                      : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorManager.primaryColor,
                      ColorManager.secondColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onAddPetPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            S.of(context).addYourFirstPet,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}