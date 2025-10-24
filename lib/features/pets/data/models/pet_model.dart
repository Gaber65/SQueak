import 'package:squeak/features/layout/post/data/model/post_model.dart';
import 'package:squeak/features/settings/data/models/owner_model.dart';

import '../../../layout/post/domain/entities/post_entity.dart';
import '../../domain/entities/pet_entity.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PetData extends PetEntities {
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
    super.passportImage,
    super.mutualFriends,
    super.passportNumber,
    super.microShipNumber,
    super.qrCode,
    super.maritalStatus,
    super.owner,
    super.availableForMating,
    super.post,
    super.petMarriage,
    super.qrCodeId,
    super.ownerId,
  });

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
      petId: json['id'] ?? '',
      owner: json['owner'] == null ? null : OwnerModel.fromJson(json['owner']),
      ownerId: json['ownerId'] ?? '',
      availableForMating: json['availableForMating'] ?? false,
      maritalStatus: json['maritalStatus'] ?? 0,
      petMarriage: json['petMarriage'] ?? [],
      post:
          json['post'] != null
              ? List<PostEntity>.from(
                json['post'].map((x) => PostDataModel.fromJson(x)),
              )
              : [],
      petName: json['petName'] ?? '',
      mutualFriends: json['mutualFriends'] ?? 0,
      breed: json["breed"] == null ? null : BreedModel.fromJson(json["breed"]),
      breedId: json['breedId'] ?? '',
      gender: json['gender'],
      isSpayed: json['isSpayed'] ?? false,
      specieId: json['specieId'] ?? '',
      isSelected: false,
      imageName:
          (json['imageName'] == null || json['imageName'] == 'PetAvatar.png')
              ? ''
              : json['imageName'],
      birthdate: json['birthdate'] ?? '',
      passportImage: json['passportImage'],
      passportNumber: json['passportNumber'] ?? json['passportnumber'],
      microShipNumber: json['microShipNumber'],
      qrCode: json['qrCode'],
      qrCodeId: json['qrCodeId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': petId,
      'petName': petName,
      'breedId': breedId?.isNotEmpty == true ? breedId : null,
      'gender': gender,
      'isSpayed': isSpayed,
      'specieId': specieId,
      'imageName': imageName,
      'birthdate': birthdate,
      'passportNumber': passportNumber,
      'passportImage': passportImage,
      'breed': breed?.toJson(),
      'microShipNumber': microShipNumber,
      'qrCode': qrCode,
      'qrCodeId': qrCodeId,
      'mutualFriends': mutualFriends,
      'isSelected': isSelected,
    };
  }
  factory PetData.empty() {
    return PetData(
      petId: '',
      petName: '',
      breedId: '',
      isSpayed: false,
      gender: 0,
      specieId: '',
      imageName: '',
      birthdate: '',
      passportImage: '',
      passportNumber: '',
      microShipNumber: '',
      qrCode: '',
      qrCodeId: '',
      mutualFriends: 0,
      isSelected: false,
      maritalStatus: 0,
      ownerId: '',
      availableForMating: false,
    );
  }
}

class BreedModel extends BreedPetEntity {
  BreedModel({required super.enBreed, required super.arBreed});

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      enBreed: json['enBreed'] ?? '',
      arBreed: json['arBreed'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {'enBreed': enBreed, 'arBreed': arBreed};
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
      id: json['id'] ?? '',
      enType: getDisplayTypeOrBreed(json),
    );
  }

  Map<String, dynamic> toMap() => {
    'enType': enType,
    'id': id,
    'specieId': specieId,
  };
}

String getDisplayTypeOrBreed(Map<String, dynamic> json) {
  final isAr = isArabic();

  if (json.containsKey('arType') || json.containsKey('enType')) {
    return isAr
        ? (json['arType'] ?? json['enType'] ?? '')
        : (json['enType'] ?? json['arType'] ?? '');
  }

  if (json.containsKey('arBreed') || json.containsKey('enBreed')) {
    return isAr
        ? (json['arBreed'] ?? json['enBreed'] ?? '')
        : (json['enBreed'] ?? json['arBreed'] ?? '');
  }

  return '';
}
