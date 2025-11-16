import 'pet_entity.dart';
class PetEntityJsonHelper {
  static PetEntities fromJson(Map<String, dynamic> json) {
    return PetEntities(
      petId: json['id'],
      petName: json['petName'],
      breedId: json['breedId'],
      isSpayed: json['isSpayed'],
      gender: json['gender'],
      specieId: json['specieId'],
      imageName: json['imageName'],
      birthdate: json['birthdate'],
      passportNumber: json['passportNumber'],
      passportImage: json['passportImage'],
      microShipNumber: json['microShipNumber'],
      qrCode: json['qrCode'],
      qrCodeId: json['qrCodeId'],
      mutualFriends: json['mutualFriends'],
      ownerId: json['ownerId'],
      maritalStatus: json['maritalStatus'] ?? 0,
      availableForMating: json['availableForMating'] ?? false,
      breed: json['breed'] != null
          ? BreedPetEntity(
              enBreed: json['breed']['enBreed'] ?? '',
              arBreed: json['breed']['arBreed'] ?? '',
            )
          : null,
    );
  }
  static List<PetEntities> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PetEntities> pets) {
    return pets.map((pet) => pet.toJson()).toList();
  }
}
