import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_avatar.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_gender_chip.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_status_chip.dart';
import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../../feeds/domain/entities/pet_mating_model.dart';

class PetProfileInfo extends StatelessWidget {
  final PetMating pet;
  final bool isDarkMode;
  final VoidCallback onEditPressed;

  const PetProfileInfo({
    super.key,
    required this.pet,
    required this.isDarkMode,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color textPrimaryColor = isDarkMode ? Colors.white : Colors.black87;
    final Color textSecondaryColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Row(
      children: [
        PetAvatar(pet: pet, isDarkMode: isDarkMode),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pet.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ColorManager.primaryColor

                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onEditPressed();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                pet.breed,
                style: TextStyle(
                  fontSize: 18,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  PetStatusChip(pet: pet),
                  const SizedBox(width: 12),
                  PetGenderChip(pet: pet, isDarkMode: isDarkMode),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
