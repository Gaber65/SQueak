import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/domain/entities/history_entities.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_avatar.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_gender_chip.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_status_chip.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/status_manager_dialog.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class PetProfileInfo extends StatelessWidget {
  final PetEntities pet;
  final bool isDarkMode;
  final ProfileMatingCubit cubit;

  const PetProfileInfo({
    super.key,
    required this.pet,
    required this.cubit,

    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color textPrimaryColor = isDarkMode ? Colors.white : Colors.black87;
    final Color textSecondaryColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Row(
      children: [
        PetAvatar(pet: pet, isDarkMode: isDarkMode),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pet.petName!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  if (pet.ownerId == CacheHelper.getData('clintId'))
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: ColorManager.primaryColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatusManagerDialog(
                                  petId: pet.petId!,
                                  listDate: statusesAlertToUpdateProfile(S.of(context)),
                                  historyId: '',
                                  cubit: cubit,
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                pet.breed?.enBreed ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  PetStatusChip(pet: pet),
                  const SizedBox(width: 12),
                  PetGenderChip(pet: pet, isDarkMode: isDarkMode),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
