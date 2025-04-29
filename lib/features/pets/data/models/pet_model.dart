import '../../domain/entities/pet_entity.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PetData extends PetEntity {
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
      'id': petId,
      'breedId': breedId.isEmpty ? null : breedId,
      'gender': gender,
      'isSpayed': isSpayed,
      'specieId': specieId,
      'imageName': imageName,
      'birthdate': birthdate,
    };
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
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'enType': enType, 'id': id, 'specieId': specieId};
  }
}
