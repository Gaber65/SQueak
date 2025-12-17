import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../generated/l10n.dart';

class PetStatusChip extends StatelessWidget {
  final PetEntities pet;

  const PetStatusChip({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            pet.availableForMating
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            pet.availableForMating
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              pet.availableForMating
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: pet.availableForMating ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            pet.availableForMating
                ? S.of(context).availableForMating
                : S.of(context).notAvailableForMating,
            style: TextStyle(
              color: pet.availableForMating ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
