import 'package:squeak/features/auth/get_started/domain/entites/request_pet_inteties.dart';

class PetRequest extends PetEntitiesss {
  PetRequest({
    String? petId,
    String? petName,
    String? breedId,
    bool? isSpayed,
    int? gender,
    String? specieId,
    String? imageName,
    String? birthdate,
  }) : super(
         petId: petId ?? '',
         petName: petName ?? '',
         breedId: breedId ?? '',
         gender: gender ?? 0,
         specieId: specieId ?? '',
         imageName: imageName ?? '',
         birthdate: birthdate ?? '',
       );

  factory PetRequest.fromJson(Map<String, dynamic> json) {
    return PetRequest(
      petId: json['id'] as String?,
      petName: json['petName'] as String?,
      breedId: json['breedId'] as String?,
      gender: json['gender'] as int?,
      specieId: json['Specieid'] as String? ?? json['specieId'] as String?,
      imageName: json['imageName'] as String?,
      birthdate: json['birthdate'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": petId.isEmpty ? null : petId,
      "petName": petName.isEmpty ? null : petName,
      "breedId": breedId.isEmpty ? null : breedId,
      "gender": gender == 0 ? null : gender,
      "specieId": specieId.isEmpty ? null : specieId,
      "imageName": imageName.isEmpty ? null : imageName,
      "birthdate": birthdate.isEmpty ? null : birthdate,
    };
  }
}
