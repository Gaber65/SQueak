import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/widget/booking_content.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/clinic/appointment_cubit.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({
    super.key,
    required this.clinicCode,
    required this.petSelectFromIcon,
    required this.pets,
  });

  final String clinicCode;
  final PetEntities? petSelectFromIcon;
  final List<PetEntities> pets;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<AppointmentCubit>()
                ..getClientINClinic(clinicCode)
                ..fetchAvailabilities(clinicCode)
                ..fetchDoctors(clinicCode),
      child: Builder(
        builder: (context) {
          final cubit = AppointmentCubit.get(context);
          return BookingContent(
            clinicCode: clinicCode,
            pets: pets,
            doctors: cubit.doctors,
            availabilities: cubit.availabilities,
            petSelectFromIcon: petSelectFromIcon,
          );
        },
      ),
    );
  }
}
