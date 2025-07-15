import 'package:flutter/material.dart';
import '../../../feeds/domain/entities/pet_mating_model.dart';

class PetGenderChip extends StatelessWidget {
  final PetMating pet;
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
            pet.gender == 'Male' ? Icons.male : Icons.female,
            size: 16,
            color: pet.gender == 'Male' ? Colors.blue : Colors.pink,
          ),
          const SizedBox(width: 6),
          Text(
            pet.gender,
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