class PetEntitiesss {
  final String petId;
  final String petName;
  final String breedId;
  final int gender;
  final String specieId;
  final String imageName;
  final String birthdate;

  PetEntitiesss({
    required this.petId,
    required this.petName,
    required this.breedId,
    required this.gender,
    required this.specieId,
    required this.imageName,
    required this.birthdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': petId,
      'petName': petName,
      if (breedId.isNotEmpty) 'breedId': breedId,
      'gender': gender,
      'specieId': specieId,
      'imageName': imageName,
      'birthdate': birthdate,
    };
  }
}
