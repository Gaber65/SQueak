import '../../domain/entities/vet_client_search_entity.dart';

class VetSearchClientModel extends VetSearchClientEntity {
  VetSearchClientModel({
    required super.id,
    required super.name,
    required super.gender,
    required super.breedId,
    required super.specieId,
    required super.imageName,
    required super.colorId,
    required super.birthdate,
    required super.clientId,
    required ClientModel super.client,
    required super.color,
    required super.breed,
    required SpecieModel? super.specie,
    required super.addedInSqueakStatues,
    required super.squeakPetId,
  });

  factory VetSearchClientModel.fromJson(Map<String, dynamic> json) {
    return VetSearchClientModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      gender: json["gender"] ?? 0,
      breedId: json["breedId"],
      specieId: json["specieId"] ?? '',
      imageName: json["imageName"] ?? '',
      colorId: json["colorId"],
      birthdate: json["birthdate"],
      clientId: json["clientId"] ?? '',
      client: ClientModel.fromJson(json["client"]),
      color: json["color"],
      breed: json["breed"],
      specie:
          json["specie"] == null ? null : SpecieModel.fromJson(json["specie"]),
      addedInSqueakStatues: json["addedInSqueakStatues"] ?? false,
      squeakPetId: json["squeakPetId"] ?? '',
    );
  }
}

class ClientModel extends ClientEntity {
  ClientModel({required super.name, required super.description});

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      name: json["name"] ?? '',
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "description": description};
}

class SpecieModel extends SpecieEntity {
  SpecieModel({required super.arType, required super.enType});

  factory SpecieModel.fromJson(Map<String, dynamic> json) {
    return SpecieModel(
      arType: json["arType"] ?? '',
      enType: json["enType"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {"arType": arType, "enType": enType};
}

class DataVetModel extends DataVetEntity {
  DataVetModel({
    required super.isRegistered,
    required super.isApplyInvitation,
    required super.vetICareId,
    required super.name,
    required super.phone,
    required super.countryId,
    required super.gender,
    required super.email,
    required super.clinicName,
    required super.clinicCode,
    required super.squeakUserId,
  });

  factory DataVetModel.fromJson(Map<String, dynamic> json) {
    return DataVetModel(
      isRegistered: json["isRegistered"],
      isApplyInvitation: json["isApplyInvitation"],
      vetICareId: json["vetICareId"],
      name: json["name"],
      phone: json["phone"],
      countryId: json["countryId"],
      gender: json["gender"],
      email: json["email"] ?? '',
      clinicName: json["clinicName"],
      clinicCode: json["clinicCode"],
      squeakUserId: json["squeakUserId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "isRegistered": isRegistered,
    "isApplyInvitation": isApplyInvitation,
    "vetICareId": vetICareId,
    "name": name,
    "phone": phone,
    "countryId": countryId,
    "gender": gender,
    "email": email,
    "clinicName": clinicName,
    "clinicCode": clinicCode,
    "squeakUserId": squeakUserId,
  };
}
