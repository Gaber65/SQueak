import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';

class CreateAppointmentUseCase
    implements BaseUseCase<Unit, CreateAppointmentParams> {
  final AppointmentRepository repository;

  CreateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CreateAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateAppointmentParams extends Equatable {
  final String petId;
  final String? doctorId;
  final String clinicCode;
  final String appointmentTime;
  final String appointmentDate;
  final int petGender;
  final String petName;
  final String clientId;
  final String petSqueakId;
  final String? specieId;
  final String? breedId;
  final bool isSpayed;
  final String? notes;
  bool isExisted;
  bool notExistedOrPet;
  bool isExistedNoPet;

  CreateAppointmentParams({
    this.isExisted = false,
    this.notExistedOrPet = false,
    this.isExistedNoPet = false,
    required this.petId,
    this.doctorId,
    required this.clinicCode,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.petGender,
    required this.petName,
    required this.clientId,
    required this.petSqueakId,
    this.specieId,
    this.breedId,

    required this.isSpayed,
    this.notes,
  });

  @override
  List<Object?> get props => [
    petId,
    doctorId,
    clinicCode,
    appointmentTime,
    appointmentDate,
    petGender,
    petName,
    clientId,
    petSqueakId,
    isExisted,
    notExistedOrPet,
    isExistedNoPet,
    isSpayed,
    notes,
  ];
}
