import 'package:flutter/material.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_stats_section.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/generated/l10n.dart';

class PetInfoPopup extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;

  const PetInfoPopup({super.key, required this.pet, required this.isDarkMode});

  String _calculateAge(String? birthdate) {
    if (birthdate == null || birthdate.isEmpty) return S.current.unknown;

    try {
      final birth = DateTime.parse(birthdate);
      final now = DateTime.now();
      final difference = now.difference(birth);

      final years = difference.inDays ~/ 365;
      final months = (difference.inDays % 365) ~/ 30;

      if (years > 0) {
        if (months > 0) {
          return '$years ${years == 1 ? 'year' : 'years'}, $months ${months == 1 ? 'month' : 'months'}';
        }
        return '$years ${years == 1 ? 'year' : 'years'}';
      } else if (months > 0) {
        return '$months ${months == 1 ? 'month' : 'months'}';
      } else {
        final days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'}';
      }
    } catch (e) {
      return S.current.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final age = _calculateAge(pet.birthdate);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header with gradient background
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDarkMode
                            ? [Colors.purple.shade800, Colors.blue.shade800]
                            : [Colors.purple.shade300, Colors.blue.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          s.petDetails,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats section with card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: PetStatsSection(
                            pet: pet,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Info cards
                      _infoCard(
                        context,
                        Icons.category_rounded,
                        s.breed,
                        pet.breed?.enBreed ?? s.unknown,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _infoCard(
                        context,
                        Icons.cake_rounded,
                        s.age,
                        age,
                        Colors.pink,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              context,
                              pet.gender.toString() == '1'
                                  ? Icons.male_rounded
                                  : Icons.female_rounded,
                              s.gender,
                              pet.gender.toString() == '1' ? s.male : s.female,
                              pet.gender.toString() == '1'
                                  ? Colors.blue
                                  : Colors.pinkAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              context,
                              Icons.medical_services_rounded,
                              s.sterilization,
                              pet.isSpayed.toString() == 'false'
                                  ? s.notSpayed
                                  : s.spayed,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _infoCard(
                        context,
                        Icons.person_rounded,
                        s.ownerDetails,
                        pet.owner?.fullName ?? s.unknown,
                        Colors.purple,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey.shade800.withOpacity(0.5)
                : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: accentColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
