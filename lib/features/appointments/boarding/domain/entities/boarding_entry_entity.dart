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
    id,
    entryDate,
    existDate,
    period,
    paymentDate,
    comment,
    status,
    boardingTypeId,
    boardingType,
    petId,
    pet,
    boardingImages,
    clinicPhone,
    clinicLocation,
    clinicLogo,
    clinicCode,
    clinicName,
    clinicId,
    cleanlinessRate,
    doctorServiceRate,
    feedbackComment,
    isRating,
    tenantId,
  ];

  BoardingEntryEntity copyWith({
    String? id,
    DateTime? entryDate,
    DateTime? existDate,
    dynamic period,
    String? paymentDate,
    String? comment,
    int? status,
    String? boardingTypeId,
    BoardingTypeEntity? boardingType,
    String? petId,
    PetBoardingEntity? pet,
    List<dynamic>? boardingImages,
    String? clinicPhone,
    String? clinicLocation,
    String? clinicLogo,
    String? clinicCode,
    String? clinicName,
    String? clinicId,
    int? cleanlinessRate,
    int? doctorServiceRate,
    String? feedbackComment,
    bool? isRating,
    String? tenantId,
  }) {
    return BoardingEntryEntity(
      id: id ?? this.id,
      entryDate: entryDate ?? this.entryDate,
      existDate: existDate ?? this.existDate,
      period: period ?? this.period,
      paymentDate: paymentDate ?? this.paymentDate,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      boardingTypeId: boardingTypeId ?? this.boardingTypeId,
      boardingType: boardingType ?? this.boardingType,
      petId: petId ?? this.petId,
      pet: pet ?? this.pet,
      boardingImages: boardingImages ?? this.boardingImages,
      clinicPhone: clinicPhone ?? this.clinicPhone,
      clinicLocation: clinicLocation ?? this.clinicLocation,
      clinicLogo: clinicLogo ?? this.clinicLogo,
      clinicCode: clinicCode ?? this.clinicCode,
      clinicName: clinicName ?? this.clinicName,
      clinicId: clinicId ?? this.clinicId,
      cleanlinessRate: cleanlinessRate ?? this.cleanlinessRate,
      doctorServiceRate: doctorServiceRate ?? this.doctorServiceRate,
      feedbackComment: feedbackComment ?? this.feedbackComment,
      isRating: isRating ?? this.isRating,
      tenantId: tenantId ?? this.tenantId,
    );
  }
}
