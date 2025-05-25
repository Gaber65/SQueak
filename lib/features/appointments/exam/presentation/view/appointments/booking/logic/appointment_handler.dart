import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/data/models/client_clinic_model.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/clinic/appointment_cubit.dart';

import '../../../../../domain/entities/client_clinic.dart';
import '../../../../../domain/use_case/create_appointment.dart';

class AppointmentHandler {
  static void createAppointment({
    required BuildContext context,
    required String petSqueakId,
    required String clinicCode,
    required DateTime selectedDate,
    required String? time,
    required String? specieId,
    required String? breedId,
    required String? note,
    required String? doctorId,
    required String petName,
    required int petGender,
    required bool? isSpayed,
  }) {
    print("DEBUG: createAppointment called$breedId");
    // Validate inputs
    if (time == null) {
      infoToast(context, isArabic() ? 'الوقت مطلوب' : 'Please select time');
      return;
    }

    if (doctorId == null || doctorId.isEmpty) {
      errorToast(
        context,
        isArabic()
            ? "يرجى اختيار طبيب من القائمة."
            : "Please select a doctor from the list.",
      );
      return;
    }

    // Format date and time
    String formatDate = DateFormat('yyyy-MM-dd', 'en_US').format(selectedDate);
    final appointmentTime = time + ':00';
    final appointmentDate = formatDate;

    // Check if user ID is available
    String squeakClientId = CacheHelper.getData('clintId') ?? '';
    if (squeakClientId.isEmpty) {
      errorToast(
        context,
        isArabic()
            ? "معرف المستخدم غير متوفر. يرجى إعادة تسجيل الدخول."
            : "User ID not available. Please log in again.",
      );
      return;
    }

    // Validate pet IDs
    if (petSqueakId.isEmpty) {
      errorToast(
        context,
        isArabic()
            ? "معرف الحيوان الأليف فارغ. يرجى اختيار حيوان أليف صالح."
            : "Pet ID is empty. Please select a valid pet.",
      );
      return;
    }

    // Show confirmation dialog
    showCustomConfirmationDialog(
      yesButtonColor: Colors.green,
      noButtonColor: Colors.red,
      titleOfAlertAR: 'تأكيد الحجز',
      titleOfAlertEN: 'Confirm Appointment',
      context: context,
      description:
          isArabic()
              ? Text.rich(
                TextSpan(
                  text: 'هل تريد حجز موعد لـ ',
                  children: [
                    TextSpan(
                      text: petName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " في تاريخ "),
                    TextSpan(text: appointmentDate),
                    TextSpan(text: '?'),
                  ],
                ),
              )
              : Text.rich(
                TextSpan(
                  text: 'Do you want to book an appointment for ',
                  children: [
                    TextSpan(
                      text: petName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " on "),
                    TextSpan(text: appointmentDate),
                    TextSpan(text: '?'),
                  ],
                ),
              ),
      imageUrl:
          'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
      onConfirm: () {
        // Get the appointment cubit
        final appointmentCubit = AppointmentCubit.get(context);

        // Find the selected pet in the petListInVet
        PetClinic? selectedPet;
        for (var pet in appointmentCubit.petListInVet) {
          if (pet.petSqueakId.contains(petSqueakId)) {
            selectedPet = pet;
            break;
          }
        }
        CreateAppointmentParams params = CreateAppointmentParams(
          breedId:breedId,
          specieId: specieId,
          notes: note,
          petId: selectedPet?.petId ?? '', // Use the petSqueakId as petId
          petSqueakId:
              selectedPet?.petSqueakId ??
              petSqueakId, // Use the petId as petSqueakId
          clinicCode: clinicCode,
          appointmentTime: appointmentTime,
          appointmentDate: appointmentDate,
          petGender: selectedPet?.petGender ?? petGender,
          petName: selectedPet?.petName ?? petName,
          clientId: appointmentCubit.clientInClinic
                  ? appointmentCubit.petListInVet.first.clientId
                  : selectedPet?.clientId ?? '',
          doctorId: doctorId,
          isSpayed: isSpayed ?? false,
        );
        AppointmentEnums appointmentStatus;

        if (appointmentCubit.clientInClinic) {
          appointmentStatus =
              selectedPet != null
                  ? AppointmentEnums.isExisted
                  : AppointmentEnums.isExistedNoPet;
        } else {
          appointmentStatus = AppointmentEnums.notExistedOrPet;
        }

        handleCreateAppointment(appointmentStatus, appointmentCubit, params);
        Navigator.pop(context);
      },
    );
  }

  static void handleCreateAppointment(
    AppointmentEnums env,
    AppointmentCubit appointmentCubit,
    CreateAppointmentParams params,
  ) {
    switch (env) {
      case AppointmentEnums.isExisted:
        params.isExisted = true;
        appointmentCubit.createNewAppointment(params);
        break;
      case AppointmentEnums.isExistedNoPet:
        params.isExistedNoPet = true;
        appointmentCubit.createNewAppointment(params);
        break;
      case AppointmentEnums.notExistedOrPet:
        params.notExistedOrPet = true;
        appointmentCubit.createNewAppointment(params);
        break;
    }
  }
}

enum AppointmentEnums { notExistedOrPet, isExisted, isExistedNoPet }
