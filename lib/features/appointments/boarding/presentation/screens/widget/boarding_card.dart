import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/boarding_entry.dart';
import '../../../domain/entities/boarding_state.dart';
import '../../cubit/boarding_cubit.dart';
import '../boarding_again.dart';
import '../boarding_rating.dart';
import '../share_image_pet_screen.dart';

class BoardingCard extends StatelessWidget {
  final BoardingEntry entry;
  final BoardingCubit cubit;

  const BoardingCard({
    super.key,
    required this.entry,
    required this.cubit,
  });

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
                          imageUrl + entry.clinicLogo),
                      radius: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            entry.pet.name,
                          ),
                          Text(
                            entry.clinicName,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(
                        BoardingStatusExtension.fromInt(entry.status)),
                    if (entry.status == BoardingStatus.paid.index &&
                        entry.status != BoardingStatus.closed.index)
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
                                    model: entry,
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
                                  )
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              onTap: () {
                                navigateToScreen(
                                  context,
                                  ImageCarouselWidget(),
                                );
                              },
                              child: Row(
                                children: [
                                  Text('Image'),
                                  Spacer(),
                                  Icon(
                                    Icons.image,
                                    color: ColorManager.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          ];
                        },
                        icon: const Icon(
                          Icons.more_vert_outlined,
                        ),
                        offset: const Offset(0, 20),
                      ),
                    if (entry.status == BoardingStatus.inProgress.index)
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
                                  ImageCarouselWidget(),
                                );
                              },
                              child: Row(
                                children: [
                                  Text('Image'),
                                  Spacer(),
                                  Icon(
                                    Icons.image,
                                    color: ColorManager.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          ];
                        },
                        icon: const Icon(
                          Icons.more_vert_outlined,
                        ),
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
                        formatBoarding(entry.entryDate)),
                    _buildInfoRow(
                        Icons.calendar_today,
                        isArabic() ? 'تاريخ الخروج' : 'Check-out',
                        formatBoarding(entry.existDate)),
                    _buildInfoRow(
                      Icons.access_time,
                      isArabic() ? 'المدة' : 'Duration',
                      '${entry.period} ${entry.period == 1 ? isArabic() ? 'يوم' : 'day' : isArabic() ? 'ايام' : 'days'}',
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
                          (index) => index < entry.doctorServiceRate
                              ? const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                )
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
                padding: const EdgeInsets.all(6),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pets,
                              size: 20, color: ColorManager.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            entry.boardingType.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          navigateToScreen(
                              context, BoardingAgain(entry: entry));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.green.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                        ),
                        child: Text(S.of(context).appointmentButtonEdit),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (entry.status != BoardingStatus.cancelled.index &&
                        entry.status != BoardingStatus.paid.index &&
                        entry.status != BoardingStatus.closed.index)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showCustomConfirmationDialog(
                              context: context,
                              description: isArabic()
                                  ? Text.rich(
                                      TextSpan(
                                        text:
                                            'هل أنت متأكد أنك تريد الغاء الاقامة ل ',
                                        children: [
                                          TextSpan(
                                            text: entry.pet.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(text: '?'),
                                        ],
                                      ),
                                    )
                                  : Text.rich(
                                      TextSpan(
                                        text:
                                            'Are you sure you want to cancel the boarding for ',
                                        children: [
                                          TextSpan(
                                            text: entry.pet.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(text: '?'),
                                        ],
                                      ),
                                    ),
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/rb_47400.png?alt=media&token=dcd29c55-5078-458c-8932-38c7f05f6224',
                              onConfirm: () async {
                                await cubit.editBoarding(
                                  ClinicCode: entry.clinicCode,
                                  entryDate: entry.entryDate,
                                  existDate: entry.existDate,
                                  period: entry.period,
                                  comment: entry.comment,
                                  boardingTypeId: entry.boardingType.id,
                                  vetICarePetId: entry.petId,
                                  id: entry.id,
                                  context: context,
                                  boardingStatus: BoardingStatus.cancelled.index,
                                );

                                Navigator.of(context).pop(true); // You can pop with true to signal confirmation.
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red,
                            backgroundColor: MainCubit.get(context).isDark
                                ? ColorManager.myPetsBaseBlackColor
                                : Colors.red.shade100.withOpacity(.4),
                            elevation: 0,
                            shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                          ),
                          child: Text(
                            S.of(context).appointmentButtonCancel,
                          ),
                        ),
                      ),
                    if (entry.status != BoardingStatus.cancelled.index &&
                        entry.status != BoardingStatus.paid.index &&
                        entry.status != BoardingStatus.closed.index)
                      const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse('tel:${entry.clinicPhone}'));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.blue.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                        ),
                        child: Text(
                          S.of(context).appointmentButtonCall,
                        ),
                      ),
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

  Widget _buildStatusChip(BoardingStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.getChipColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.getDisplayText(isArabic()),
        style: TextStyle(
          color: status.getTextColor(),
          fontSize: 12,
        ),
      ),
    );
  }
}
