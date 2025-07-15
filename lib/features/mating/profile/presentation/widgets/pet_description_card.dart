import 'package:flutter/material.dart';
import '../../../feeds/domain/entities/pet_mating_model.dart';

class PetDescriptionCard extends StatelessWidget {
  final PetMating pet;
  final bool isDarkMode;

  const PetDescriptionCard({
    super.key,
    required this.pet,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color textSecondaryColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            Colors.blue.shade900.withOpacity(0.2),
            Colors.purple.shade900.withOpacity(0.1),
          ]
              : [
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.blue.shade700.withOpacity(0.3)
              : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              pet.description!,
              style: TextStyle(
                fontSize: 15,
                color: textSecondaryColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}