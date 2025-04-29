class PetEntity {
  final dynamic id;
  final String name;
  final String breedId;
  final bool isSpayed;
  final int gender;
  final dynamic specieId;
  final dynamic imageName;
  final String birthdate;
  final BreedEntity? breed;
  final bool isSelected;

  const PetEntity({
    required this.id,
    required this.name,
    required this.breedId,
    required this.isSpayed,
    required this.gender,
    required this.specieId,
    required this.imageName,
    required this.birthdate,
    this.breed,
    this.isSelected = false,
  });
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

  const SpeciesEntity({
    required this.id,
    required this.type,
  });
}