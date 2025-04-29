class PetEntity {
  final String petId;
  final String petName;
  final String breedId;
  final bool isSpayed;
  final int gender;
  final dynamic specieId;
  final dynamic imageName;
  final String birthdate;
  final BreedEntity? breed;
  bool isSelected;

  PetEntity({
    required this.petId,
    required this.petName,
    required this.breedId,
    required this.isSpayed,
    required this.gender,
    required this.specieId,
    required this.imageName,
    required this.birthdate,
    this.breed,
    this.isSelected = false,
  });
  Map<String, dynamic> toJson() => {
    'petId': petId,
    'petName': petName,
    'breedId': breedId.isEmpty ? null : breedId,
    'gender': gender,
    'isSpayed': isSpayed,
    'specieId': specieId,
    'imageName': imageName,
    'birthdate': birthdate,
  };
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
}

class SpeciesEntity {
  final String id;
  final String type;

  const SpeciesEntity({required this.id, required this.type});
}
