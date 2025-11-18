import 'package:flutter/material.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_stats_section.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/generated/l10n.dart';

class PetInfoPopup extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PetInfoPopup({super.key, required this.pet, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      s.petDetails,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PetStatsSection(pet: pet, isDarkMode: isDarkMode),
                const SizedBox(height: 16),
                _infoRow(
                  context,
                  Icons.pets,
                  s.breed,
                  pet.breed?.enBreed ?? s.unknown,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  context,
                  Icons.person,
                  s.ownerDetails,
                  pet.owner?.fullName ?? s.unknown,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  context,
                  Icons.location_on_rounded,
                  s.gender,
                  pet.gender.toString() == '1' ? s.male : s.female,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  context,
                  Icons.info_outline,
                  s.birthdate,
                  pet.birthdate ?? s.unknown,
                ),
                _infoRow(
                  context,
                  Icons.info_outline,
                  s.sterilization,
                  pet.isSpayed.toString() == 'false' ? s.notSpayed : s.spayed,
                ),
                const SizedBox(height: 16),
                if ((pet.post.isNotEmpty))
                  Text(s.posts, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDark = isDarkMode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black54),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
