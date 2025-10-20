import 'package:flutter/material.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../core/utils/theme/color_mangment/color_manager.dart';

class PetAvatar extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PetAvatar({
    super.key,
    required this.pet,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pet.imageName!.isNotEmpty && pet.imageName != imageUrl;

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
        child:hasImage ? CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              imageUrl +pet.imageName!,

              fit: BoxFit.cover,
            ),
          ),
        ) : CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          child: Text(
             pet.petName![0].toUpperCase(),
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