import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_description_card.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_profile_info.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_stats_section.dart';
import '../../../feeds/domain/entities/pet_mating_model.dart';

class PetProfileHeader extends StatelessWidget {
  final PetMating pet;
  final bool isDarkMode;
  final VoidCallback onEditPressed;

  const PetProfileHeader({
    super.key,
    required this.pet,
    required this.isDarkMode,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: Decorations.kDecorationBoxShadow(context: context, radius: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            PetProfileInfo(
              pet: pet,
              isDarkMode: isDarkMode,
              onEditPressed: onEditPressed,
            ),
            const SizedBox(height: 24),
            PetStatsSection(pet: pet, isDarkMode: isDarkMode),
            if (pet.description != null) ...[
              const SizedBox(height: 20),
              PetDescriptionCard(pet: pet, isDarkMode: isDarkMode),
            ],
          ],
        ),
      ),
    );
  }
}
