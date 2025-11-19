import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/profile/domain/entities/history_entities.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_avatar.dart';
import 'package:squeak/features/mating/profile/presentation/widgets/pet_gender_chip.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double avatarSize =
            (maxWidth < 350)
                ? 70
                : (maxWidth < 600)
                ? 90
                : 110;
        final double nameFontSize =
            (maxWidth < 350)
                ? 20
                : (maxWidth < 600)
                ? 26
                : 30;

        final double breedFontSize = (maxWidth < 350) ? 13 : 17;
        final double editIconSize = (maxWidth < 350) ? 18 : 22;
        final double editPadding = (maxWidth < 350) ? 8 : 12;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: PetAvatar(pet: pet, isDarkMode: isDarkMode),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.verified,
                      size: avatarSize * 0.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: maxWidth < 360 ? 14 : 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.petName!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                                color: textPrimaryColor,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.pets,
                                  size: breedFontSize - 1,
                                  color: textSecondaryColor.withOpacity(0.7),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    pet.breed?.enBreed ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: breedFontSize,
                                      color: textSecondaryColor,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Container(
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     gradient: LinearGradient(
                      //       colors: [
                      //         Theme.of(context).primaryColor,
                      //         Theme.of(context).primaryColor.withOpacity(0.7),
                      //       ],
                      //       begin: Alignment.topLeft,
                      //       end: Alignment.bottomRight,
                      //     ),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Theme.of(context).primaryColor.withOpacity(0.4),
                      //         blurRadius: 8,
                      //         offset: const Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Material(
                      //     color: Colors.transparent,
                      //     child: InkWell(
                      //       onTap: () {
                      //         showModalBottomSheet(
                      //           context: context,
                      //           isScrollControlled: true,
                      //           backgroundColor: Colors.transparent,
                      //           builder:
                      //               (context) => PetInfoPopup(
                      //                 pet: pet,
                      //                 isDarkMode: isDarkMode,
                      //               ),
                      //         );
                      //       },
                      //       customBorder: const CircleBorder(),
                      //       child: Padding(
                      //         padding: EdgeInsets.all(editPadding),
                      //         child: Icon(
                      //           Icons.pets,
                      //           size: editIconSize ,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      if (pet.ownerId == CacheHelper.getData('clintId')) ...[
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepOrange.shade400,
                                Colors.orange.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepOrange.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
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
                                      listDate: statusesAlertToUpdateProfile(
                                        S.of(context),
                                      ),
                                      historyId: '',
                                      cubit: cubit,
                                    );
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(14),
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
                    ],
                  ),
                  SizedBox(height: maxWidth < 360 ? 10 : 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      // PetStatusChip(pet: pet),
                      PetGenderChip(pet: pet, isDarkMode: isDarkMode),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
