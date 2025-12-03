import 'package:squeak/features/settings/domain/entities/owner_entite.dart';

import '../../../layout/post/domain/entities/post_entity.dart';

class PetEntities {
  final String? petId;
  final String? petName;
  final String? breedId;
  final bool? isSpayed;
  final int? gender;
  final Owner? owner;
  final String? specieId;
  final String? imageName;
  final String? birthdate;
  final String? passportNumber;
  final String? passportImage;
  final String? microShipNumber;
  final String? qrCode;
  final String? qrCodeId;
  final BreedPetEntity? breed;
  final int? mutualFriends;
  final String? ownerId;
  final int maritalStatus;
  final bool availableForMating;
  final List<PostEntity> post;
  final List<dynamic> petMarriage;
  bool isSelected;
  final String? conversationId;

  PetEntities({
    this.petId,
    this.petName,
    this.breedId,
    this.isSpayed,
    this.gender,
    this.specieId,
    this.imageName,
    this.birthdate,
    this.passportNumber,
    this.passportImage,
    this.microShipNumber,
    this.qrCode,
    this.qrCodeId,
    this.breed,
    this.mutualFriends,
    this.ownerId,
    this.owner,
    this.conversationId,

    this.maritalStatus = 0,
    this.availableForMating = false,
    this.post = const [],
    this.petMarriage = const [],
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': petId,
      'petName': petName,
      if (breedId != null && breedId!.isNotEmpty) 'breedId': breedId,
      'isSpayed': isSpayed,
      'gender': gender,
      'specieId': specieId,
      'imageName': imageName,
      'birthdate': birthdate,
      'passportNumber': passportNumber,
      'passportImage': passportImage,
      'microShipNumber': microShipNumber,
      'qrCode': qrCode,
      'qrCodeId': qrCodeId,
      'mutualFriends': mutualFriends,
      'owner': owner?.toMap(),
      'maritalStatus': maritalStatus,
      'availableForMating': availableForMating,
      'post': post.map((e) => e.toJson()).toList(),
      'petMarriage': petMarriage,
      'breed': breed?.toJson(),
      'ownerId': ownerId,
      'isSelected': isSelected,
    };
  }

  /// to do copyWith
  PetEntities copyWith({String? petId}) =>
      PetEntities(petId: this.petId ?? petId);
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

  Map<String, dynamic> toJson() => {'enBreed': enBreed, 'arBreed': arBreed};
}

extension PetValidator on PetEntities {
  bool get isValid {
    return petName != null &&
        petName!.trim().isNotEmpty &&
        gender != null &&
        specieId != null &&
        specieId!.trim().isNotEmpty &&
        breedId != null &&
        breedId!.trim().isNotEmpty &&
        imageName != null &&
        imageName!.trim().isNotEmpty;
  }
}
