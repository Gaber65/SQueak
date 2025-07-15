import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/widget/booking_content.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/clinic/appointment_cubit.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({
    super.key,
    required this.selectedDate,
    required this.timeSlotData,
    required this.clinicCode,
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppointmentCubit>()..getClientINClinic(clinicCode),

      child: BookingContent(
        selectedDate: selectedDate,
        clinicCode: clinicCode,
        timeSlotData: timeSlotData,
        doctors: doctors,
        pets: pets,
        petSelectFromIcon: petSelectFromIcon,
      ),
    );
  }
}
