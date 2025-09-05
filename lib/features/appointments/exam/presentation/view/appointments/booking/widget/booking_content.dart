import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/widget/no_have_pet.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/widget/pet_carousel.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/clinic/appointment_cubit.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';

import '../../../component/CustomCalendarDatePicker.dart';
import '../logic/appointment_handler.dart';
import 'comment_input_field.dart';
import 'doctor_dropdown.dart';

class BookingContent extends StatefulWidget {
  const BookingContent({
    super.key,
    required this.selectedDate,
    required this.clinicCode,
    required this.timeSlotData,
    required this.doctors,
    required this.petSelectFromIcon,
    required this.pets,
  });

  final DateTime selectedDate;
  final List<Availability> timeSlotData;
  final String clinicCode;
  final List<Doctor> doctors;
  final PetEntities? petSelectFromIcon;
  final List<PetEntities> pets;

  @override
  State<BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<BookingContent> {
  String? doctorId;
  String? doctorImage;
  String? doctorName;
  String? time;
  bool initTheSelectedPetValue = false;

  PetEntities? petSelect;
  @override
  void initState() {
    super.initState();

    if (widget.petSelectFromIcon != null) {
      petSelect = widget.petSelectFromIcon;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (CacheHelper.getInt('havePets') == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInfoNoPetDialog(navigatorKey.currentContext);
      });
    }
  }

  void _showInfoNoPetDialog(context) async {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.all(12),
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: SizedBox(
            width: MediaQuery.of(context).size.height * 20,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: NoHavePetAlert(),
            ),
          ),
        );
      },
    ).whenComplete(() {
      navigateToScreen(context, PetScreen());
    });
  }

  void handleCreateAppointment(BuildContext context) {
    AppointmentHandler.createAppointment(
      context: context,
      petSqueakId: petSelect!.petId,
      clinicCode: widget.clinicCode,
      selectedDate: widget.selectedDate,
      time: time,
      doctorId: doctorId,
      petName: petSelect!.petName,
      petGender: petSelect!.gender,
      isSpayed: petSelect!.isSpayed,
      specieId: petSelect!.specieId,
      breedId: petSelect!.breedId,
      note: AppointmentCubit.get(context).commentController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listener: (context, state) {
        if (state is CreateAppointmentsSuccess) {
          successToast(
            context,
            isArabic()
                ? 'تم حجز الموعد بنجاح'
                : 'Appointment booked successfully',
          );
          LayoutCubit.get(context).changeBottomNav(2);
          navigateAndFinish(context, LayoutScreen());
        } else if (state is CreateAppointmentsError) {
          errorToast(context, state.errorMessageModel);
        }
      },
      builder: (context, state) {
        final cubit = AppointmentCubit.get(context);

        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).startAppointment),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor.withOpacity(
                          .2,
                        ),
                      ),
                      onPressed:
                          cubit.isLoading
                              ? null
                              : () {
                                if (time == null) {
                                  infoToast(
                                    context,
                                    isArabic()
                                        ? 'الوقت مطلوب'
                                        : 'Please select time',
                                  );
                                } else {
                                  handleCreateAppointment(context);
                                }
                              },
                      child:
                          cubit.isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                S.of(context).booking,
                                style: FontStyleThame.textStyle(
                                  context: context,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontColor: ColorManager.primaryColor,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommentInputField(
                controller: cubit.commentController,
                isLoading: cubit.isLoading,
                onSubmit: () {
                  handleCreateAppointment(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.petSelectFromIcon == null)
                      PetCarousel(
                        pets: widget.pets,
                        onPetSelected: (firstPet) {
                          setState(() {
                            petSelect = firstPet;
                            initTheSelectedPetValue = true;
                          });
                        },
                        initializeFirstPet: !initTheSelectedPetValue,
                      ),

                    const SizedBox(height: 15),
                    DoctorDropdown(
                      doctors: widget.doctors,
                      selectedDoctorId: doctorId,
                      selectedDoctorImage: doctorImage,
                      selectedDoctorName: doctorName,
                      onDoctorSelected: (doctor) {
                        setState(() {
                          doctorImage = doctor.image;
                          doctorId = doctor.id;
                          doctorName = doctor.name;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        isArabic()
                            ? 'من فضلك اختار وقت الحجز'
                            : 'Please select time for reservation',
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    CalendarScreen(
                      isShowTime: true,
                      isShowDate: false,
                      timeSlotData: widget.timeSlotData,
                      selectedDate: widget.selectedDate,
                      onIntervalSelected: (selectedTime) {
                        final formattedTime = convertTo24Hour(selectedTime);
                        final now = DateTime.now();
                        final selectedHour = int.parse(
                          formattedTime.split(':')[0],
                        );
                        final selectedMinute = int.parse(
                          formattedTime.split(':')[1],
                        );

                        final isToday = widget.selectedDate.isAtSameMomentAs(
                          DateTime(now.year, now.month, now.day),
                        );

                        if (!isToday ||
                            selectedHour > now.hour ||
                            (selectedHour == now.hour &&
                                selectedMinute > now.minute)) {
                          setState(() => time = formattedTime);
                        } else {
                          infoToast(
                            context,
                            isArabic()
                                ? 'الساعة المحددة قبل الساعة الحالية'
                                : 'Selected time is before current time',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
