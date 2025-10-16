import '../../domain/entities/boarding_entry_entity.dart';
import 'boarding_type_model.dart';
import 'pet_boarding_model.dart';

class BoardingEntryModel extends BoardingEntryEntity {
  const BoardingEntryModel({
    required super.id,
    required super.entryDate,
    required super.existDate,
    required super.period,
    super.paymentDate,
    required super.comment,
    super.status,
    required super.boardingTypeId,
    required super.boardingType,
    required super.petId,
    required super.pet,
    required super.boardingImages,
    required super.clinicPhone,
    required super.clinicLocation,
    super.clinicLogo,
    required super.clinicCode,
    required super.clinicName,
    required super.clinicId,
    required super.cleanlinessRate,
    required super.doctorServiceRate,
    super.feedbackComment,
    required super.isRating,
    required super.tenantId,
  });

  factory BoardingEntryModel.fromJson(Map<String, dynamic> json) {
    return BoardingEntryModel(
      id: json['id'],
      entryDate: DateTime.parse(json['entryDate']),
      existDate: DateTime.parse(json['existDate']),
      period: json['period'],
      paymentDate: json['paymentDate'],
      comment: json['comment'],
      status: json['status'],
      boardingTypeId: json['boardingTypeId'],
      boardingType: BoardingTypeModel.fromJson(json['boardingType']),
      petId: json['petId'],
      pet: PetBoardingModel.fromJson(json['pet']),
      boardingImages: List<dynamic>.from(json['boardingImages']),
      clinicPhone: json['clinicPhone'],
      clinicLocation: json['clinicLocation'],
      clinicLogo: json['clinicLogo'],
      clinicCode: json['clinicCode'],
      clinicName: json['clinicName'],
      clinicId: json['clinicId'],
      cleanlinessRate: json['cleanlinessRate'],
      doctorServiceRate: json['doctorServiceRate'],
      feedbackComment: json['feedbackComment'],
      isRating: json['isRating'] ?? false,
      tenantId: json['tenantId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entryDate': entryDate.toIso8601String(),
      'existDate': existDate.toIso8601String(),
      'period': period,
      'paymentDate': paymentDate,
      'comment': comment,
      'status': status,
      'boardingTypeId': boardingTypeId,
      'boardingType': (boardingType as BoardingTypeModel).toJson(),
      'petId': petId,
      'pet': (pet as PetBoardingModel).toJson(),
      'boardingImages': boardingImages,
      'clinicPhone': clinicPhone,
      'clinicLocation': clinicLocation,
      'clinicLogo': clinicLogo,
      'clinicCode': clinicCode,
      'clinicName': clinicName,
      'clinicId': clinicId,
      'cleanlinessRate': cleanlinessRate,
      'doctorServiceRate': doctorServiceRate,
      'feedbackComment': feedbackComment,
      'isRating': isRating,
      'tenantId': tenantId,
    };
  }

  BoardingEntryEntity toEntity() {
    return BoardingEntryEntity(
      id: id,
      entryDate: entryDate,
      existDate: existDate,
      period: period,
      paymentDate: paymentDate,
      comment: comment,
      status: status,
      boardingTypeId: boardingTypeId,
      boardingType: (boardingType as BoardingTypeModel).toEntity(),
      petId: petId,
      pet: (pet as PetBoardingModel).toEntity(),
      boardingImages: boardingImages,
      clinicPhone: clinicPhone,
      clinicLocation: clinicLocation,
      clinicLogo: clinicLogo,
      clinicCode: clinicCode,
      clinicName: clinicName,
      clinicId: clinicId,
      cleanlinessRate: cleanlinessRate,
      doctorServiceRate: doctorServiceRate,
      feedbackComment: feedbackComment,
      isRating: isRating,
      tenantId: tenantId,
    );
  }
}
class VideoEntity {
  final String url;
  final String? description;

  VideoEntity({
    required this.url,
    this.description,
  });

  factory VideoEntity.fromJson(Map<String, dynamic> json) {
    return VideoEntity(
      url: json['url'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'description': description,
    };
  }
}