import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/features/appointments/boarding/domain/repositories/boarding_repository.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/boarding_entry_entity.dart';
import '../../../domain/entities/boarding_status.dart';
import '../../../domain/usecases/share_image_usecase.dart';
import '../../cubit/boarding_cubit.dart';
import '../boarding_again.dart';
import '../boarding_rating.dart';
import '../share_image_pet_screen.dart';

class BoardingCard extends StatelessWidget {
  final BoardingEntryEntity entry;
  final BoardingCubit cubit;

  const BoardingCard({super.key, required this.entry, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: FastCachedImageProvider(
                        imageUrlWithVetICare + (entry.clinicLogo ?? ''),
                      ),
                      radius: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(entry.pet.name),
                          Text(entry.clinicName),
                        ],
                      ),
                    ),
                    _buildStatusChip(
                      BoardingStatusExtension.fromInt(entry.status ?? 0),
                    ),
                    if (entry.status == BoardingStatusEnums.paid.index &&
                        entry.status != BoardingStatusEnums.closed.index)
                      PopupMenuButton<int>(
                        padding: EdgeInsets.zero,
                        onCanceled: () {
                          Navigator.of(context);
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 2,
                              onTap: () {
                                navigateToScreen(
                                  context,
                                  RateBoarding(
                                    boardingEntryEntity: entry,
                                    isNav: true,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text('Rate'),
                                  Spacer(),
                                  Icon(
                                    Icons.star_border_purple500,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => ImageCarouselWidget(
                                        open: true,
                                        onOpenChange:
                                            (open) => Navigator.pop(context),
                                        boarding: entry,
                                        onShare: (imageUrl, platform) {
                                          cubit.shareImageEntries(
                                            ShareImageBoardingEntriesParams(
                                              imageUrl: imageUrl,
                                              platform: platform,
                                            ),
                                          );
                                        },
                                      ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text('Image'),
                                  Spacer(),
                                  Icon(
                                    Icons.image,
                                    color: ColorManager.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                        icon: const Icon(Icons.more_vert_outlined),
                        offset: const Offset(0, 20),
                      ),
                    if (entry.status == BoardingStatusEnums.inProgress.index)
                      PopupMenuButton<int>(
                        padding: EdgeInsets.zero,
                        onCanceled: () {
                          Navigator.of(context);
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 2,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => ImageCarouselWidget(
                                        open: true,
                                        onOpenChange:
                                            (open) => Navigator.pop(context),
                                        boarding: entry,
                                        onShare: (imageUrl, platform) {
                                          cubit.shareImageEntries(
                                            ShareImageBoardingEntriesParams(
                                              imageUrl: imageUrl,
                                              platform: platform,
                                            ),
                                          );
                                        },
                                      ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text('Image'),
                                  Spacer(),
                                  Icon(
                                    Icons.image,
                                    color: ColorManager.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                        icon: const Icon(Icons.more_vert_outlined),
                        offset: const Offset(0, 20),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.calendar_today,
                      isArabic() ? 'تاريخ الحجز' : 'Check-in',
                      formatBoarding(entry.entryDate.toString()),
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      isArabic() ? 'تاريخ الخروج' : 'Check-out',
                      formatBoarding(entry.existDate.toString()),
                    ),
                    _buildInfoRow(
                      Icons.access_time,
                      isArabic() ? 'المدة' : 'Duration',
                      '${entry.period} ${entry.period == 1
                          ? isArabic()
                              ? 'يوم'
                              : 'day'
                          : isArabic()
                          ? 'ايام'
                          : 'days'}',
                    ),
                  ],
                ),
              ),
              if (entry.status == 3 && entry.doctorServiceRate != 0)
                Center(
                  child: Row(
                    children: [
                      Text(
                        isArabic() ? 'تقييم الطبيب' : 'Doctor rating : ',
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) =>
                              index < entry.doctorServiceRate
                                  ? const Icon(Icons.star, color: Colors.amber)
                                  : const Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.pets,
                            size: 20,
                            color: ColorManager.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entry.boardingType.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          launchUrl(Uri.parse('tel:${entry.clinicPhone}'));
                        },
                        icon: Icon(
                          Icons.call,
                          size: 20,
                          color: ColorManager.primaryColor,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(6),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: ElevatedButton(
              //           onPressed: () {
              //             navigateToScreen(
              //               context,
              //               BoardingAgain(entry: entry),
              //             );
              //           },
              //           style: ElevatedButton.styleFrom(
              //             foregroundColor: Colors.green,
              //             backgroundColor:
              //                 MainCubit.get(context).isDark
              //                     ? ColorManager.myPetsBaseBlackColor
              //                     : Colors.green.shade100.withOpacity(.4),
              //             elevation: 0,
              //             shape: (RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             )),
              //           ),
              //           child: Text(S.of(context).appointmentButtonEdit),
              //         ),
              //       ),
              //       const SizedBox(width: 6),
              //       if (entry.status != BoardingStatusEnums.cancelled.index &&
              //           entry.status != BoardingStatusEnums.paid.index &&
              //           entry.status != BoardingStatusEnums.closed.index)
              //         Expanded(
              //           child: ElevatedButton(
              //             onPressed: () {
              //               showCustomConfirmationDialog(
              //                 context: context,
              //                 description:
              //                     isArabic()
              //                         ? Text.rich(
              //                           TextSpan(
              //                             text:
              //                                 'هل أنت متأكد أنك تريد الغاء الاقامة ل ',
              //                             children: [
              //                               TextSpan(
              //                                 text: entry.pet.name,
              //                                 style: TextStyle(
              //                                   fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                               TextSpan(text: '?'),
              //                             ],
              //                           ),
              //                         )
              //                         : Text.rich(
              //                           TextSpan(
              //                             text:
              //                                 'Are you sure you want to cancel the boarding for ',
              //                             children: [
              //                               TextSpan(
              //                                 text: entry.pet.name,
              //                                 style: TextStyle(
              //                                   fontWeight: FontWeight.bold,
              //                                 ),
              //                               ),
              //                               TextSpan(text: '?'),
              //                             ],
              //                           ),
              //                         ),
              //                 imageUrl:
              //                     'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/rb_47400.png?alt=media&token=dcd29c55-5078-458c-8932-38c7f05f6224',
              //                 onConfirm: () async {
              //                   var editModel = EditBoardingParams(
              //                     clinicCode: entry.clinicCode,
              //                     entryDate: entry.entryDate.toString(),
              //                     existDate: entry.existDate.toString(),
              //                     period: entry.period,
              //                     comment: entry.comment,
              //                     boardingTypeId: entry.boardingType.id,
              //                     vetICarePetId: entry.petId,
              //                     id: entry.id,
              //                     boardingStatus:
              //                         BoardingStatusEnums.cancelled.index,
              //                   );
              //                   await cubit.editBoarding(editModel);
              //
              //                   Navigator.of(context).pop(
              //                     true,
              //                   ); // You can pop with true to signal confirmation.
              //                 },
              //               );
              //             },
              //             style: ElevatedButton.styleFrom(
              //               foregroundColor: Colors.red,
              //               backgroundColor:
              //                   MainCubit.get(context).isDark
              //                       ? ColorManager.myPetsBaseBlackColor
              //                       : Colors.red.shade100.withOpacity(.4),
              //               elevation: 0,
              //               shape: (RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(12),
              //               )),
              //             ),
              //             child: Text(S.of(context).appointmentButtonCancel),
              //           ),
              //         ),
              //       if (entry.status != BoardingStatusEnums.cancelled.index &&
              //           entry.status != BoardingStatusEnums.paid.index &&
              //           entry.status != BoardingStatusEnums.closed.index)
              //         const SizedBox(width: 6),
              //       Expanded(
              //         child: ElevatedButton(
              //           onPressed: () {
              //             launchUrl(Uri.parse('tel:${entry.clinicPhone}'));
              //           },
              //           style: ElevatedButton.styleFrom(
              //             foregroundColor: Colors.blue,
              //             backgroundColor:
              //                 MainCubit.get(context).isDark
              //                     ? ColorManager.myPetsBaseBlackColor
              //                     : Colors.blue.shade100.withOpacity(.4),
              //             elevation: 0,
              //             shape: (RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             )),
              //           ),
              //           child: Text(S.of(context).appointmentButtonCall),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: ColorManager.primaryColor),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BoardingStatusEnums status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.getChipColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.getDisplayText(isArabic()),
        style: TextStyle(color: status.getTextColor(), fontSize: 12),
      ),
    );
  }
}
