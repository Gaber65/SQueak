import 'package:equatable/equatable.dart';

class VaccinationEntity extends Equatable {
  final String id;
  final String petId;
  final String vaccinationId;
  final String vacDate;
  final bool status;
  final String comment;
  final VaccinationNameEntity vaccination;

  const VaccinationEntity({
    required this.id,
    required this.petId,
    required this.vaccinationId,
    required this.vacDate,
    required this.status,
    required this.comment,
    required this.vaccination,
  });

  @override
  List<Object> get props => [
    id,
    petId,
    vaccinationId,
    vacDate,
    status,
    comment,
    vaccination,
  ];
}

class VaccinationNameEntity extends Equatable {
  final String vacName;
  final String vacID;

  const VaccinationNameEntity({required this.vacName, required this.vacID});

  @override
  List<Object> get props => [vacName, vacID];
}
