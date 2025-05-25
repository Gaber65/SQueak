
import 'boarding_type.dart';

class BoardingEntry {
  final String id;
  final String entryDate;
  final String existDate;
  final double period;
  final String? paymentDate;
  final String comment;
  final int status;
  final ClinicBoardEntity boardingType;
  final String petId;
  final Pet pet;
  final List<dynamic> boardingImages;
  final String clinicPhone;
  final String clinicLocation;
  final String clinicLogo;
  final String clinicCode;
  final String clinicName;
  final String clinicId;
  final int cleanlinessRate;
  final int doctorServiceRate;
  final String? feedbackComment;
  final dynamic isRating;
  final String tenantId;

  BoardingEntry({
    required this.id,
    required this.entryDate,
    required this.existDate,
    required this.period,
    this.paymentDate,
    required this.comment,
    required this.status,
    required this.boardingType,
    required this.petId,
    required this.pet,
    required this.boardingImages,
    required this.clinicPhone,
    required this.clinicLocation,
    required this.clinicLogo,
    required this.clinicCode,
    required this.clinicName,
    required this.clinicId,
    required this.cleanlinessRate,
    required this.doctorServiceRate,
    this.feedbackComment,
    this.isRating,
    required this.tenantId,
  });

  factory BoardingEntry.fromJson(Map<String, dynamic> json) {
    return BoardingEntry(
      id: json['id'],
      entryDate: json['entryDate'],
      existDate: json['existDate'],
      period: json['period'].toDouble(),
      paymentDate: json['paymentDate'],
      comment: json['comment'],
      status: json['status'],
      boardingType: ClinicBoardEntity.fromJson(json['boardingType']),
      petId: json['petId'],
      pet: Pet.fromJson(json['pet']),
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entryDate': entryDate,
      'existDate': existDate,
      'period': period,
      'paymentDate': paymentDate,
      'comment': comment,
      'status': status,
      'boardingType': boardingType.toJson(),
      'petId': petId,
      'pet': pet.toMap(),
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
}

class Pet {
  final String name;

  Pet({required this.name});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(name: json['name']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
