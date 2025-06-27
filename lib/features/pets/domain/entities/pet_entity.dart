class PetEntities {
  final String petId;
  final String petName;
  final String breedId;
  final bool isSpayed;
  final int gender;
  final String specieId;
  final String imageName;
  final String birthdate;
  final String? passportNumber;
  final String? passportImage;
  final String? microShipNumber;
  final String? qrCode;
  final String? qrCodeId;
  final BreedPetEntity? breed;
  bool isSelected;

  PetEntities({
    required this.petId,
    required this.petName,
    required this.breedId,
    required this.isSpayed,
    required this.gender,
    required this.specieId,
    required this.imageName,
    required this.birthdate,
    this.passportNumber,
    this.microShipNumber,
    this.qrCode,
    this.qrCodeId,
    this.passportImage,
    this.breed,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': petId,
      'petName': petName,
      if (breedId.isNotEmpty) 'breedId': breedId,
      'isSpayed': isSpayed,
      'gender': gender,
      'specieId': specieId,
      'imageName': imageName,
      'birthdate': birthdate,
      'passportnumber': passportNumber,
      'passportImage': passportImage,
    };
  }
}

class BreedEntity {
  final String enType;
  final String id;
  final String specieId;

  const BreedEntity({
    required this.enType,
    required this.id,
    required this.specieId,
  });

  Map<String, dynamic> toJson() => {
    'enType': enType,
    'id': id,
    'specieId': specieId,
  };
}

class SpeciesEntity {
  final String id;
  final String type;

  const SpeciesEntity({required this.id, required this.type});
}
class BreedPetEntity {
  final String enBreed;
  final String arBreed;

  BreedPetEntity({required this.enBreed, required this.arBreed});

  Map<String, dynamic> toJson() => {
    'enBreed': enBreed,
    'arBreed': arBreed,
  };
}
