import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../generated/l10n.dart';

class PetGenderChip extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PetGenderChip({
    super.key,
    required this.pet,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            Colors.grey.shade700,
            Colors.grey.shade800,
          ]
              : [
            Colors.grey.shade100,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.shade600
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            pet.gender == 1 ? Icons.male : Icons.female,
            size: 16,
            color: pet.gender == 1 ? Colors.blue : Colors.pink,
          ),
          const SizedBox(width: 6),
          Text(
            pet.gender == 1 ? S.of(context).male : S.of(context).female ,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}