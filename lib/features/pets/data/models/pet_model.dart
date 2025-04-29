import '../../domain/entities/pet_entity.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PetModel extends ErrorMessageModel {
  final List<PetData> pets;

  const PetModel({
    required super.errors,
    required super.message,
    required super.success,
    required super.statusCode,
    required this.pets,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      errors: ErrorMessageModel.convertJsonToMap(json['errors']),
      message: json['message'],
      statusCode: json['statusCode'],
      success: json['success'],
      pets: List<PetData>.from(json['pets'].map((x) => PetData.fromJson(x))),
    );
  }
}

class PetData {
  final dynamic petId;
  final dynamic specieId;
  BreedData? breed;
  final String petName;
  final String breedId;
  final bool isSpayed;
  bool isSelected;
  final int gender;
  dynamic imageName;
  final String birthdate;

  PetData({
    required this.petId,
    required this.petName,
    this.isSelected = false,
    required this.breedId,
    required this.isSpayed,
    required this.gender,
    this.breed,
    required this.specieId,
    required this.imageName,
    required this.birthdate,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      petId: json['id'],
      petName: json['petName'],
      breed: json['breed'] == null ? null : BreedData.fromJson(json['breed']),
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petName': petName,
      'breedId': breedId,
      'gender': gender,
      'isSpayed': isSpayed,
      'specieId': specieId,
      'imageName': imageName,
      'birthdate': birthdate,
    };
  }

  PetEntity toEntity() {
    return PetEntity(
      id: petId,
      name: petName,
      breedId: breedId,
      isSpayed: isSpayed,
      gender: gender,
      specieId: specieId,
      imageName: imageName,
      birthdate: birthdate,
      breed: breed,
      isSelected: isSelected,
    );
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
      enType:
          json['arType'] != null
              ? (isArabic() ? json['arType'] : json['enType']) ?? 'Unknown Type'
              : (isArabic() ? json['arBreed'] : json['enBreed']) ??
                  'Unknown Breed',
      id: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'enType': enType, 'id': id, 'specieId': specieId};
  }
}
