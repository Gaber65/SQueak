import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_profile_info.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_stats_section.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class PetProfileHeader extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;
  final ProfileMatingCubit cubit;

  const PetProfileHeader({
    super.key,
    required this.pet,
    required this.cubit,

    required this.isDarkMode,
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
              cubit: cubit,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 24),
            PetStatsSection(pet: pet, isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }
}
