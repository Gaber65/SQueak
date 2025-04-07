import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/helper/image_helper/helper_model/response_model.dart';

class PetModel extends ResponseModel {
  final List<PetsData> pets;

  PetModel({
    required super.errors,
    required super.message,
    required super.success,
    required super.statusCode,
    required this.pets,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      errors: ResponseModel.convertJsonToMap(json['errors']),
      message: json['message'],
      statusCode: json['statusCode'],
      success: json['success'],
      pets: List<PetsData>.from(json['pets'].map((x) => PetsData.fromJson(x))),
    );
  }
}

class PetsData {
  final dynamic petId;
  final dynamic specieId;
  Bread? breed;
  final String petName;
  final String breedId;
  final bool isSpayed;
  bool isSelected;
  final int gender;
  dynamic imageName;
  final String birthdate;

  PetsData({
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

  factory PetsData.fromJson(Map<String, dynamic> json) {
    return PetsData(
      petId: json['id'],
      petName: json['petName'],
      breed: json['breed'] == null ? null : Bread.fromJson(json['breed']),
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

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'petName': petName,
      'breedId': breedId,
      'gender': gender,
      'imageName': imageName,
      'birthdate': birthdate,
    };
  }
}

class Bread {
  final String enType;

  const Bread({
    required this.enType,
  });

  factory Bread.fromJson(Map<String, dynamic> json) {
    return Bread(
      enType: isArabic() ? json['arBreed'] : json['enBreed'],
    );
  }
}

class BreadData {
  final String enType;
  final String id;
  final String specieId;

  const BreadData({
    required this.enType,
    required this.id,
    required this.specieId,
  });

  factory BreadData.fromJson(Map<String, dynamic> json) {
    return BreadData(
      specieId: json['specieId'] ?? '',
      enType: json['arType'] != null
          ? (isArabic() ? json['arType'] : json['enType']) ?? 'Unknown Type'
          : (isArabic() ? json['arBreed'] : json['enBreed']) ?? 'Unknown Breed',
      id: json['id'],
    );
  }
}
