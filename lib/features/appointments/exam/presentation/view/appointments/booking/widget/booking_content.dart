// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/all_apointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/widget/no_have_pet.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/clinic/appointment_cubit.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';

import '../logic/appointment_handler.dart';
import 'comment_input_field.dart';
import 'components/booking_app_bar.dart';
import 'components/booking_content_body.dart';

class BookingContent extends StatefulWidget {
  const BookingContent({
    super.key,
    required this.clinicCode,
    required this.petSelectFromIcon,
    required this.pets,
    required this.doctors,
    required this.availabilities,
  });

  final String clinicCode;
  final PetEntities? petSelectFromIcon;
  final List<PetEntities> pets;
  final List<Doctor> doctors;
  final List<Availability> availabilities;

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
    _checkForPets();
  }

  void _checkForPets() {
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

  void _handleCreateAppointment(BuildContext context) {
    if (time == null) {
      infoToast(
        context,
        isArabic() ? 'الوقت مطلوب' : 'Please select time',
      );
      return;
    }

    if (petSelect == null) {
      infoToast(
        context,
        isArabic() ? 'الرجاء اختيار حيوان أليف' : 'Please select a pet',
      );
      return;
    }

    AppointmentHandler.createAppointment(
      context: context,
      petSqueakId: petSelect!.petId ?? '',
      clinicCode: widget.clinicCode,
      selectedDate: DateTime.parse(AppointmentCubit.get(context).dateController.text),
      time: time,
      doctorId: doctorId,
      petName: petSelect!.petName ?? '',
      petGender: petSelect!.gender ?? 0,
      isSpayed: petSelect!.isSpayed,
      specieId: petSelect!.specieId,
      breedId: petSelect!.breedId,
      note: AppointmentCubit.get(context).commentController.text,
    );
  }

  void _onPetSelected(PetEntities pet) {
    setState(() {
      petSelect = pet;
      initTheSelectedPetValue = true;
    });
  }

  void _onDoctorSelected(Doctor doctor) {
    setState(() {
      doctorImage = doctor.image;
      doctorId = doctor.id;
      doctorName = doctor.name;
    });
  }

  void _onTimeSelected(String selectedTime) {
    setState(() {
      time = selectedTime;
    });
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

          navigateAndFinish(context, AllAppointment());
        } else if (state is CreateAppointmentsError) {
          errorToast(context, state.errorMessageModel);
        }
      },
      builder: (context, state) {
        final cubit = AppointmentCubit.get(context);

        return WillPopScope(
          onWillPop: () async  {
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            appBar: BookingAppBar(
              isLoading: cubit.isLoading,
              onBookingPressed: () => _handleCreateAppointment(context),
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: CommentInputField(
              controller: cubit.commentController,
              isLoading: cubit.isLoading,
              onSubmit: () => _handleCreateAppointment(context),
            ),
            body: BookingContentBody(
              clinicCode: widget.clinicCode,
              petSelectFromIcon: widget.petSelectFromIcon,
              pets: widget.pets,
              doctors: widget.doctors,
              availabilities: widget.availabilities,
              isLoading: cubit.isLoading,
              selectedPet: petSelect,
              selectedTime: time,
              onPetSelected: _onPetSelected,
              onDoctorSelected: _onDoctorSelected,
              onTimeSelected: _onTimeSelected,
              initializeFirstPet: !initTheSelectedPetValue,
            ),
          ),
        );
      },
    );
  }
}