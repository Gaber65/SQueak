import '../../domain/entities/pet_entity.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PetData extends PetEntities {
  PetData({
    required super.petId,
    required super.petName,
    required super.breedId,
    required super.isSpayed,
    required super.gender,
    required super.specieId,
    required super.imageName,
    required super.birthdate,
    super.breed,
    super.isSelected,
    super.passportImage,
    super.passportNumber,
    super.microShipNumber,
    super.qrCode,
    super.qrCodeId,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      petId: json['id'],
      petName: json['petName'],
      breed: json["breed"] == null ? null : BreedModel.fromJson(json["breed"]),

      breedId: json['breedId'] ?? '',
      gender: json['gender'],
      isSpayed: json['isSpayed'] ?? false,
      specieId: json['specieId'] ?? '',
      isSelected: false,
      imageName:
          json['imageName'] == null || json['imageName'] == 'PetAvatar.png'
              ? ''
              : json['imageName'],
      birthdate: json['birthdate'] ?? '',
      passportImage: json['passportImage'],
      passportNumber: json['passportnumber'],
      microShipNumber: json['microShipNumber'],
      qrCode: json['qrCode'],
      qrCodeId: json['qrCodeId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'petName': petName,
      'id': petId,
      'breedId': breedId.isEmpty ? null : breedId,
      'gender': gender,
      'isSpayed': isSpayed,
      'specieId': specieId,
      'imageName': imageName,
      'birthdate': birthdate,
      'passportnumber': passportNumber,
      'passportImage': passportImage,
      'breed': breed?.toJson(),
      'microShipNumber': microShipNumber,
    };
  }
}

class BreedModel extends BreedPetEntity {
  BreedModel({required super.enBreed, required super.arBreed});

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(enBreed: json['enBreed'], arBreed: json['arBreed']);
  }

  Map<String, dynamic> toMap() {
    return {'enBreed': enBreed, 'arBreed': arBreed};
  }
}

class BreedData extends BreedEntity {
  BreedData({
    required super.enType,
    required super.id,
    required super.specieId,
  });

  factory BreedData.fromJson(Map<String, dynamic> json) {
    return BreedData(
      specieId: json['specieId'] ?? '',
      id: json['id'] ?? '',
      enType: getDisplayTypeOrBreed(json),
    );
  }

  Map<String, dynamic> toMap() {
    return {'enType': enType, 'id': id, 'specieId': specieId};
  }
}

String getDisplayTypeOrBreed(Map<String, dynamic> json) {
  final isAr = isArabic();

  // Priority 1: Species object (enType/arType)
  if (json.containsKey('arType') || json.containsKey('enType')) {
    return isAr
        ? (json['arType'] ?? json['enType'] ?? '')
        : (json['enType'] ?? json['arType'] ?? '');
  }

  // Priority 2: Breed object (enBreed/arBreed)
  if (json.containsKey('arBreed') || json.containsKey('enBreed')) {
    return isAr
        ? (json['arBreed'] ?? json['enBreed'] ?? '')
        : (json['enBreed'] ?? json['arBreed'] ?? '');
  }

  // Default fallback
  return '';
}
