import '../../domain/entities/pet_boarding_entity.dart';

class PetBoardingModel extends PetBoardingEntity {
  const PetBoardingModel({required super.name});

  factory PetBoardingModel.fromJson(Map<String, dynamic> json) {
    return PetBoardingModel(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  PetBoardingEntity toEntity() {
    return PetBoardingEntity(name: name);
  }
}
