import 'package:flutter/material.dart';
import 'package:squeak/generated/l10n.dart';

import '../../../controller/pet_cubit.dart';
import 'dropdown_widgets.dart';

class BreedSpeciesSection extends StatelessWidget {
  const BreedSpeciesSection({
    super.key,
    required this.cubit,
    required this.isDark,
  });

  final PetCubit cubit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).breed,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildDropDownBreed(cubit.breedData, context, cubit),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).species,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildDropDownSpecies(cubit.species, context, cubit),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
