import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';
import 'package:squeak/features/appointments/exam/presentation/view/component/custom_calendar_date_picker.dart';
import '../../../../../pets/domain/entities/pet_entity.dart';
import '../../../domain/entities/clinic_entity.dart';
import '../appointments/booking/booking_screen.dart';
import '../component/whats_appbar.dart';
import '../appointments/book_again_screen.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AppointmentCubit>()),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentCubit, AppointmentState>(
            listener: (context, state) {
              if (state is UnfollowSuccess) {
                CacheHelper.removeData('posts');
                LayoutCubit.get(context).changeBottomNav(1);
                navigateToScreen(context, LayoutScreen());
              }
            },
          ),
          BlocListener<PetCubit, PetState>(listener: (context, state) {}),
        ],
        child: BlocBuilder<AppointmentCubit, AppointmentState>(
          builder: (context, state) {
            final appointmentCubit = AppointmentCubit.get(context);
            final petCubit = PetCubit.get(context);
            final pets = petCubit.pets;

            return Stack(
              children: [
                VcLoadingOverlay(
                  isLoading: state is GetAvailabilityLoading,
                  message:
                      state is GetAvailabilityLoading
                          ? (isArabic()
                              ? 'جاري تحميل المواعيد المتاحة...'
                              : 'Loading availability...')
                          : null,
                  child: Scaffold(
                    body: SafeArea(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          /// AppBar
                          SliverPersistentHeader(
                            delegate: WhatsappAppbar(
                              clinics: clinicInfo.data,
                              screenWidth: MediaQuery.of(context).size.width,
                              context: context,
                            ),
                            pinned: true,
                          ),

                          /// Clinic Info + Buttons
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                PhoneAndName(
                                  clinicName: clinicInfo.data.name,
                                  speciality:
                                      clinicInfo.data.specialities.isEmpty
                                          ? ''
                                          : clinicInfo
                                              .data
                                              .specialities
                                              .first
                                              .name,
                                  phone:
                                      clinicInfo.data.phone.startsWith('10') ||
                                              clinicInfo.data.phone.startsWith(
                                                '11',
                                              ) ||
                                              clinicInfo.data.phone.startsWith(
                                                '12',
                                              ) ||
                                              clinicInfo.data.phone.startsWith(
                                                '15',
                                              )
                                          ? '0${clinicInfo.data.phone}'
                                          : clinicInfo.data.phone,
                                ),
                                ProfileIconButtons(clinics: clinicInfo.data),
                              ],
                            ),
                          ),

                          /// Main Body
                          WhatsappProfileBody(
                            list: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    isArabic()
                                        ? 'الرجاء الضغط على يوم من الأسبوع لبدء الحجز'
                                        : 'Please click on day of week to start booking',
                                    style: FontStyleThame.textStyle(
                                      fontWeight: FontWeight.w500,
                                      context: context,
                                      fontColor: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                /// Doctors Status Indicator
                                if (state is GetDoctorLoading)
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isArabic()
                                              ? 'جاري تحضير بيانات الأطباء...'
                                              : 'Preparing doctors data...',
                                          style: FontStyleThame.textStyle(
                                            context: context,
                                            fontColor: Colors.orange,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (appointmentCubit.doctors.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isArabic()
                                              ? '${appointmentCubit.doctors.length} طبيب متاح'
                                              : '${appointmentCubit.doctors.length} doctors available',
                                          style: FontStyleThame.textStyle(
                                            context: context,
                                            fontColor: Colors.green,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                /// Calendar view
                                Builder(
                                  builder: (context) {
                                    if (appointmentCubit
                                        .availabilities
                                        .isEmpty) {
                                      return CalendarShimmer();
                                    } else {
                                      return SizedBox(
                                        height: 410,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CalendarScreen(
                                            isShowTime: false,
                                            timeSlotData:
                                                appointmentCubit.availabilities,
                                            isShowDate: true,
                                            onDaySelected: (
                                              selectedDay,
                                              focusedDay,
                                            ) {
                                              appointmentCubit.selectedDate =
                                                  selectedDay;

                                              navigateToScreen(
                                                context,
                                                BookingScreen(
                                                  clinicCode:
                                                      clinicInfo.data.code,
                                                  petSelectFromIcon:
                                                      petSelectFromIcon,
                                                  pets: pets,
                                                ),
                                              );

                                              // Clear any loading states after navigation
                                              // appointmentCubit.emit(GetAvailabilitySuccess());
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),

                                // /// Empty message (if needed)
                                // if (appointmentCubit.availabilities.isEmpty)
                                //   Center(
                                //     child: Container(
                                //       constraints:
                                //       const BoxConstraints(maxWidth: 400),
                                //       margin: const EdgeInsets.all(16),
                                //       child: Card(
                                //         color: MainCubit.get(context).isDark
                                //             ? Colors.black26
                                //             : Colors.white,
                                //         elevation: 4,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(8),
                                //         ),
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(24),
                                //           child: Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             children: [
                                //               const Icon(
                                //                 Icons.event_busy,
                                //                 size: 64,
                                //                 color: Colors.red,
                                //               ),
                                //               const SizedBox(height: 24),
                                //               Text(
                                //                 isArabic()
                                //                     ? 'لا توجد أوقات متاحة'
                                //                     : 'No Available Time Slots',
                                //                 style: const TextStyle(
                                //                   fontSize: 24,
                                //                   fontWeight: FontWeight.bold,
                                //                 ),
                                //               ),
                                //               const SizedBox(height: 16),
                                //               Text(
                                //                 isArabic()
                                //                     ? 'عذرا😔، لا يوجد وقت متاح. يرجى التواصل مع إدارة العيادة.'
                                //                     : 'Sorry😔, there is no available time. Please contact the clinic admin.',
                                //                 textAlign: TextAlign.center,
                                //                 style: const TextStyle(fontSize: 16),
                                //               ),
                                //               const SizedBox(height: 24),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Separate overlay for unfollow action
                if (state is UnFollowLoading)
                  VcLoadingOverlay(
                    isLoading: true,
                    message:
                        isArabic()
                            ? 'جاري إلغاء المتابعة...'
                            : 'Unfollowing clinic...',
                    child: Container(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
