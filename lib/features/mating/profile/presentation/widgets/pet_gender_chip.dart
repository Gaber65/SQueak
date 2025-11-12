import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../generated/l10n.dart';

class PetGenderChip extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PetGenderChip({super.key, required this.pet, required this.isDarkMode});

  String _getMaritalStatusText(BuildContext context, int status) {
    switch (status) {
      case 0:
        return S.of(context).single;
      case 1:
        return S.of(context).availableForMating;
      case 2:
        return S.of(context).married;
      case 3:
        return S.of(context).divorced;
      case 4:
        return S.of(context).pregnant;
      case 5:
        return S.of(context).has_set_its_baby;
      case 6:
        return S.of(context).not_available;
      case 7:
        return S.of(context).onMating;
      default:
        return S.of(context).not_available;
    }
  }

  Color _getMaritalStatusColor(int status) {
    switch (status) {
      case 1: // Available for mating
        return Colors.green;
      case 2: // Married
        return Colors.red;
      case 4: // Pregnant
        return Colors.purple;
      case 6: // Not Available
        return Colors.red;
      case 7: // In Mating Process
        return Colors.orange;
      default:
        return isDarkMode ? Colors.white70 : Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDarkMode
                      ? [Colors.grey.shade700, Colors.grey.shade800]
                      : [Colors.grey.shade100, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
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
                pet.gender == 1 ? S.of(context).male : S.of(context).female,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
 ],
          ),
        ),
       const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getMaritalStatusColor(pet.maritalStatus).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getMaritalStatusColor(pet.maritalStatus),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                size: 14,
                color: _getMaritalStatusColor(pet.maritalStatus),
              ),
              const SizedBox(width: 6),
              Text(
                _getMaritalStatusText(context, pet.maritalStatus),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getMaritalStatusColor(pet.maritalStatus),
                ),
              ),
            ],
          ),
        ),
      const Spacer()
      ],
    );
  }
}
