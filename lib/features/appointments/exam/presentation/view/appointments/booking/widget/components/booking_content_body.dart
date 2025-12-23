// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/widget/pet_carousel.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../../../../../core/service/global_function/format_utils.dart';
import '../../../../../../../../../core/service/global_widget/toast.dart';
import '../../../../../controller/clinic/appointment_cubit.dart';
import '../../../../component/custom_calendar_date_picker.dart';
import '../../../book_again_screen.dart';
import '../doctor_dropdown.dart';

class BookingContentBody extends StatefulWidget {
  const BookingContentBody({
    super.key,
    required this.clinicCode,
    required this.petSelectFromIcon,
    required this.pets,
    required this.doctors,
    required this.availabilities,
    required this.isLoading,
    required this.selectedPet,
    required this.selectedTime,
    required this.onPetSelected,
    required this.onDoctorSelected,
    required this.onTimeSelected,
    required this.initializeFirstPet,
  });

  final String clinicCode;
  final PetEntities? petSelectFromIcon;
  final List<PetEntities> pets;
  final List<Doctor> doctors;
  final List<Availability> availabilities;
  final bool isLoading;
  final PetEntities? selectedPet;
  final String? selectedTime;
  final Function(PetEntities) onPetSelected;
  final Function(Doctor) onDoctorSelected;
  final Function(String) onTimeSelected;
  final bool initializeFirstPet;

  @override
  State<BookingContentBody> createState() => _BookingContentBodyState();
}

class _BookingContentBodyState extends State<BookingContentBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.petSelectFromIcon == null)
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                ), // margin-bottom: var(--spacing-20)
                padding: const EdgeInsets.all(20), // padding: var(--spacing-20)
                decoration: BoxDecoration(
                  color:
                      Theme.of(
                        context,
                      ).colorScheme.surface, // background: var(--surface-color)
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // border-radius: var(--radius-12)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.09,
                      ), // rgba(0, 0, 0, 0.05)
                      blurRadius: 8, // 0 2px 8px
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: PetCarousel(
                  pets: widget.pets,
                  onPetSelected: widget.onPetSelected,
                  initializeFirstPet: widget.initializeFirstPet,
                ),
              ),

            const SizedBox(height: 15),

            BlocConsumer<AppointmentCubit, AppointmentState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ), // margin-bottom: var(--spacing-20)
                  padding: const EdgeInsets.all(
                    20,
                  ), // padding: var(--spacing-20)
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .surface, // background: var(--surface-color)
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // border-radius: var(--radius-12)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.09,
                        ), // rgba(0, 0, 0, 0.05)
                        blurRadius: 8, // 0 2px 8px
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DoctorDropdown(
                    doctors: AppointmentCubit.get(context).doctors,
                    onDoctorSelected: widget.onDoctorSelected,
                    isLoading: widget.isLoading,
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            BlocConsumer<AppointmentCubit, AppointmentState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (AppointmentCubit.get(context).availabilities.isEmpty) {
                  return CalendarShimmer();
                } else {
                  return Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ), // margin-bottom: var(--spacing-20)
                    padding: const EdgeInsets.all(
                      20,
                    ), // padding: var(--spacing-20)
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context)
                              .colorScheme
                              .surface, // background: var(--surface-color)
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // border-radius: var(--radius-12)
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.09,
                          ), // rgba(0, 0, 0, 0.05)
                          blurRadius: 8, // 0 2px 8px
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CalendarScreen(
                      isShowTime: true,
                      isShowDate: true,
                      timeSlotData:
                          AppointmentCubit.get(context).availabilities,
                      onDaySelected: (selectedDay, focusedDay) {
                        String formatDate = DateFormat(
                          'yyyy-MM-dd',
                          'en_US',
                        ).format(selectedDay);
                        if (mounted) {
                          setState(
                            () =>
                                AppointmentCubit.get(context)
                                    .dateController
                                    .text = formatDate,
                          );
                        }
                      },
                      onIntervalSelected: (p0) {

                        p0 = convertTo24Hour(p0);

                        if (AppointmentCubit.get(
                          context,
                        ).dateController.text.isEmpty) {
                          // Ensure date is selected first
                          infoToast(
                            context,
                            isArabic()
                                ? 'الرجاء تحديد التاريخ أولاً'
                                : 'Please select a data first',
                          );
                          return;
                        }
                        DateTime selectedDateForCheck = DateTime.parse(
                          AppointmentCubit.get(context).dateController.text,
                        );
                        if (DateTime.now().isBefore(selectedDateForCheck) ||
                            (DateTime.now().year == selectedDateForCheck.year &&
                                DateTime.now().month ==
                                    selectedDateForCheck.month &&
                                DateTime.now().day ==
                                    selectedDateForCheck.day)) {
                          try {
                            final parts = p0.split(':');
                            int hours = int.parse(parts[0]);
                            int minutes =
                                parts.length > 1 ? int.parse(parts[1]) : 0;
                            DateTime selectedDateTime = DateTime(
                              selectedDateForCheck.year,
                              selectedDateForCheck.month,
                              selectedDateForCheck.day,
                              hours,
                              minutes,
                            );
                            DateTime nowForCompare = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              DateTime.now().hour,
                              DateTime.now().minute,
                            );

                            if (selectedDateForCheck.isAfter(
                                  DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  ),
                                ) ||
                                selectedDateTime.isAfter(nowForCompare)) {
                              if (mounted) {
                                setState(() {
                                  AppointmentCubit.get(context).time.text = p0;
                                  widget.onTimeSelected(p0);
                                });
                              }
                            } else {
                              // print(
                              //   "DEBUG: Selected time is before current time",
                              // );
                              infoToast(
                                context,
                                isArabic()
                                    ? 'الساعة المحددة قبل الساعة الحالية'
                                    : 'Selected time is before current time',
                              );
                            }
                          } catch (e) {

                            infoToast(
                              context,
                              isArabic()
                                  ? 'خطأ في تنسيق الوقت'
                                  : 'Error in time format',
                            );
                          }
                        } else {

                          infoToast(
                            context,
                            isArabic()
                                ? 'لا يمكن تحديد تاريخ في الماضي'
                                : 'Cannot select a past data',
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
