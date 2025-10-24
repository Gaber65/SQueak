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

    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      final double avatarSize = (maxWidth < 350)
          ? 60
          : (maxWidth < 600)
              ? 80
              : 100;
      final double nameFontSize = (maxWidth < 350)
          ? 18
          : (maxWidth < 600)
              ? 24
              : 28;

      final double breedFontSize = (maxWidth < 350) ? 12 : 16;
      final double editIconSize = (maxWidth < 350) ? 16 : 20;
      final double editPadding = (maxWidth < 350) ? 6 : 10;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: PetAvatar(pet: pet, isDarkMode: isDarkMode),
          ),
          SizedBox(width: maxWidth < 360 ? 12 : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        pet.petName!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: nameFontSize,
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
                            child: Padding(
                              padding: EdgeInsets.all(editPadding),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: editIconSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: maxWidth < 360 ? 6 : 8),
                Text(
                  pet.breed?.enBreed ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: breedFontSize,
                    color: textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: maxWidth < 360 ? 8 : 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    PetStatusChip(pet: pet),
                    PetGenderChip(pet: pet, isDarkMode: isDarkMode),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
