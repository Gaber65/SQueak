import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/presentation/view/component/CustomCalendarDatePicker.dart';
import '../../../../../pets/domain/entities/pet_entity.dart';
import '../../../domain/entities/clinic_entity.dart';
import '../../controller/clinic/appointment_cubit.dart';
import '../appointments/book_again_screen.dart';
import '../appointments/booking/booking_screen.dart';
import '../component/whatsAppBar.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({
    super.key,
    required this.clinicInfo,
    this.petSelectFromIcon,
  });

  final ClinicInfo clinicInfo;
  final PetEntities? petSelectFromIcon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<AppointmentCubit>()
                ..fetchAvailabilities(clinicInfo.data.code)
                ..fetchDoctors(clinicInfo.data.code),
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is UnfollowSuccess) {
            CacheHelper.removeData('posts');

            LayoutCubit.get(context).changeBottomNav(1);
            navigateToScreen(context, LayoutScreen());
          }
        },
        builder: (context, state) {
          var cubit = AppointmentCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  //image
                  SliverPersistentHeader(
                    delegate: WhatsappAppbar(
                      clinics: clinicInfo.data,
                      screenWidth: MediaQuery.of(context).size.width,
                      context: context,
                    ),
                    pinned: true,
                  ),

                  //unfollow && message button
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        PhoneAndName(
                          clinicName: clinicInfo.data.name,
                          speciality:
                              clinicInfo.data.specialities.isEmpty
                                  ? ''
                                  : clinicInfo.data.specialities.first.name,
                          phone:
                              clinicInfo.data.phone.startsWith('10') ||
                                      clinicInfo.data.phone.startsWith('11') ||
                                      clinicInfo.data.phone.startsWith('12') ||
                                      clinicInfo.data.phone.startsWith('15')
                                  ? '0${clinicInfo.data.phone} '
                                  : clinicInfo.data.phone,
                        ),
                        ProfileIconButtons(clinics: clinicInfo.data),
                      ],
                    ),
                  ),

                  WhatsappProfileBody(
                    list: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isArabic()
                                ? 'الرجاء الضغط على يوم من الأسبوع لبدء الحجز '
                                : 'Please click on day of week to start booking',
                            style: FontStyleThame.textStyle(
                              fontWeight: FontWeight.w500,
                              context: context,
                              fontColor: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        (AppointmentCubit.get(context).availabilities.isEmpty)
                            ? CalendarShimmer()
                            : (AppointmentCubit.get(
                              context,
                            ).availabilities.isNotEmpty)
                            ? SizedBox(
                              height: 410,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CalendarScreen(
                                  isShowTime: false,
                                  timeSlotData: cubit.availabilities,
                                  isShowDate: true,
                                  onDaySelected: (selectedDay, focusedDay) {
                                    cubit.selectedDate = selectedDay;
                                    navigateToScreen(
                                      context,
                                      BookingScreen(
                                        timeSlotData: cubit.availabilities,
                                        selectedDate: selectedDay,
                                        doctors: cubit.doctors,
                                        clinicCode: clinicInfo.data.code,
                                        petSelectFromIcon: petSelectFromIcon,
                                      ),
                                    );
                                    cubit.emit(GetAvailabilitySuccess());
                                  },
                                ),
                              ),
                            )
                            : Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 400,
                                ),
                                margin: const EdgeInsets.all(16),
                                child: Card(
                                  color:
                                      MainCubit.get(context).isDark
                                          ? Colors.black26
                                          : Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.event_busy,
                                          size: 64,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          isArabic()
                                              ? 'لا توجد أوقات متاحة'
                                              : 'No Available Time Slots',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          isArabic()
                                              ? 'عذرا😔، لا يوجد وقت متاح. يرجى التواصل مع إدارة العيادة.'
                                              : 'Sorry😔, there is no available time . Please contact the clinic admin.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // bottomNavigationBar: (cubit.selectedDate != null)
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: SizedBox(
            //           width: double.infinity,
            //           height: 50,
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(8),
            //               ),
            //               backgroundColor: ColorManager.primaryColor,
            //             ),
            //             onPressed: () {
            //               navigateToScreen(
            //                 context,
            //                 BookingScreen(
            //                   timeSlotData: cubit.availabilities,
            //                   selectedDate: cubit.selectedDate!,
            //                   doctors: cubit.doctors,
            //                   clinicCode: clinicInfo.data.code,
            //                 ),
            //               );
            //             },
            //             child: Text(S.of(context).booking),
            //           ),
            //         ),
            //       )
            //     : null,
          );
        },
      ),
    );
  }
}
