import 'package:flutter/material.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../../feeds/domain/entities/pet_mating_model.dart';

class PetAvatar extends StatelessWidget {
  final PetMating pet;
  final bool isDarkMode;

  const PetAvatar({
    super.key,
    required this.pet,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(1),
            ColorManager.primaryColor.withOpacity(.4),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          child: Text(
            pet.name[0].toUpperCase(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}