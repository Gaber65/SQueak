import 'package:flutter/material.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/stat_item.dart';
import '../../../feeds/domain/entities/pet_mating_model.dart';


class PetStatsSection extends StatelessWidget {
  final PetMating pet;
  final bool isDarkMode;

  const PetStatsSection({
    super.key,
    required this.pet,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            Colors.grey.shade800.withOpacity(0.5),
            Colors.grey.shade900.withOpacity(0.2),
          ]
              : [
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.shade700.withOpacity(0.5)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            icon: Icons.calendar_today_rounded,
            label: 'Age',
            value: pet.age.isEmpty ? 'Unknown' : pet.age,
            color: Colors.blue,
            isDarkMode: isDarkMode,
          ),
          StatItem(
            icon: Icons.location_on_rounded,
            label: 'Location',
            value: 'Cairo, Egypt',
            color: Colors.green,
            isDarkMode: isDarkMode,
          ),
          StatItem(
            icon: Icons.star_rounded,
            label: 'Rating',
            value: '4.8',
            color: Colors.amber,
            isDarkMode: isDarkMode,
          ),
          StatItem(
            icon: Icons.favorite_rounded,
            label: 'Matches',
            value: '12',
            color: Colors.pink,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }
}