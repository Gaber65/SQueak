import 'package:equatable/equatable.dart';
import 'boarding_type_entity.dart';
import 'pet_boarding_entity.dart';

class BoardingEntryEntity extends Equatable {
  final String id;
  final DateTime entryDate;
  final DateTime existDate;
  final dynamic period;
  final String? paymentDate;
  final String comment;
  final int? status;
  final String boardingTypeId;
  final BoardingTypeEntity boardingType;
  final String petId;
  final PetBoardingEntity pet;
  final List<dynamic> boardingImages;
  final String clinicPhone;
  final String clinicLocation;
  final String? clinicLogo;
  final String clinicCode;
  final String clinicName;
  final String clinicId;
  final int cleanlinessRate;
  final int doctorServiceRate;
  final String? feedbackComment;
  final bool isRating;
  final String tenantId;

  const BoardingEntryEntity({
    required this.id,
    required this.entryDate,
    required this.existDate,
    required this.period,
    this.paymentDate,
    required this.comment,
    this.status,
    required this.boardingTypeId,
    required this.boardingType,
    required this.petId,
    required this.pet,
    required this.boardingImages,
    required this.clinicPhone,
    required this.clinicLocation,
    this.clinicLogo,
    required this.clinicCode,
    required this.clinicName,
    required this.clinicId,
    required this.cleanlinessRate,
    required this.doctorServiceRate,
    this.feedbackComment,
    required this.isRating,
    required this.tenantId,
  });

  @override
  List<Object?> get props => [
    id, entryDate, existDate, period, paymentDate, comment, status,
    boardingTypeId, boardingType, petId, pet, boardingImages,
    clinicPhone, clinicLocation, clinicLogo, clinicCode, clinicName,
    clinicId, cleanlinessRate, doctorServiceRate, feedbackComment,
    isRating, tenantId
  ];
}
