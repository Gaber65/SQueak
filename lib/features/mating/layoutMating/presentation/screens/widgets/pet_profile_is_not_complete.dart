import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/presentation/view/edit_pet_screen.dart';

import '../../../../../pets/domain/entities/pet_entity.dart';

class PetProfileIncompleteScreen extends StatelessWidget {
  final PetEntities pet;

  const PetProfileIncompleteScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Main Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      isDark ? const Color(0xFF232323) : Colors.grey[100]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: ColorManager.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Warning Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorManager.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        size: 40,
                        color: ColorManager.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      S.of(context).profile_incomplete,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      S.of(context).profile_incomplete_desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Missing Fields Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorManager.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).missing_information,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColorManager.primaryColor,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 12),
                          ..._buildMissingFieldsList(context, pet),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => navigateToScreen(context, LayoutScreen()),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              S.of(context).maybe_later,
                              style: TextStyle(
                                color:
                                    isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              navigateToScreen(
                                context,
                                EditPet(pets: pet, breedData: [],),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              S.of(context).complete_now,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Features Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.withOpacity(0.05),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_open,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).features_unlock,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      context,
                      S.of(context).pet_friendship,
                      Icons.pets,
                    ),
                    _buildFeatureItem(
                      context,
                      S.of(context).mating_features,
                      Icons.favorite,
                    ),
                    _buildFeatureItem(
                      context,
                      S.of(context).health_tracking,
                      Icons.monitor_heart,
                    ),
                    _buildFeatureItem(
                      context,
                      S.of(context).community_access,
                      Icons.people,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMissingFieldsList(BuildContext context, PetEntities pet) {
    final missingFields = <Widget>[];

    if (pet.petName!.isEmpty) {
      missingFields.add(
        _buildMissingFieldItem(
          context,
          S.of(context).missing_field_pet_name,
          Icons.badge,
        ),
      );
    }
    if (pet.gender == null) {
      missingFields.add(
        _buildMissingFieldItem(
          context,
          S.of(context).missing_field_gender,
          Icons.male,
        ),
      );
    }
    if (pet.specieId!.isEmpty) {
      missingFields.add(
        _buildMissingFieldItem(
          context,
          S.of(context).missing_field_species,
          Icons.category,
        ),
      );
    }
    if (pet.breedId!.isEmpty) {
      missingFields.add(
        _buildMissingFieldItem(
          context,
          S.of(context).missing_field_breed,
          Icons.pets,
        ),
      );
    }
    if (pet.imageName!.isEmpty) {
      missingFields.add(
        _buildMissingFieldItem(
          context,
          S.of(context).missing_field_photo,
          Icons.photo_camera,
        ),
      );
    }
    if (pet.birthdate == null) {
      missingFields.add(
        _buildMissingFieldItem(
          context,
          S.of(context).missing_field_birth_date,
          Icons.cake,
        ),
      );
    }

    if (missingFields.isEmpty) {
      missingFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            S.of(context).all_required_complete,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return missingFields;
  }

  Widget _buildMissingFieldItem(
    BuildContext context,
    String fieldName,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ColorManager.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fieldName,
              style: const TextStyle(color: ColorManager.primaryColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              S.of(context).required,
              style: const TextStyle(
                color: ColorManager.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String feature,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            feature,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ],
      ),
    );
  }

}
