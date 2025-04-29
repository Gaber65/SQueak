import '../../domain/entities/vet_client.dart';

class VetClientModel extends VetClient {
  const VetClientModel({
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

  factory VetClientModel.fromJson(Map<String, dynamic> json) => VetClientModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        gender: json["gender"] ?? 0,
        breedId: json["breedId"] ?? '',
        specieId: json["specieId"] ?? '',
        imageName: json["imageName"] ?? '',
        colorId: json["colorId"] ?? '',
        birthdate: json["birthdate"] ?? '',
        clientId: json["clientId"] ?? '',
        client: ClientModel.fromJson(json["client"] ?? {}),
        color: json["color"] ?? '',
        breed: json["breed"] ?? '',
        specie: json["specie"] == null ? null : SpecieModel.fromJson(json["specie"]),
        addedInSqueakStatues: json["addedInSqueakStatues"] ?? false,
        squeakPetId: json["squeakPetId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "breedId": breedId,
        "specieId": specieId,
        "imageName": imageName,
        "colorId": colorId,
        "birthdate": birthdate,
        "clientId": clientId,
        "client": (client as ClientModel).toJson(),
        "color": color,
        "breed": breed,
        "specie": specie != null ? (specie as SpecieModel).toJson() : null,
        "addedInSqueakStatues": addedInSqueakStatues,
        "squeakPetId": squeakPetId,
      };
}

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.name,
    required super.description,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        name: json["name"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
      };
}

class SpecieModel extends SpecieEntity {
  const SpecieModel({
    required super.arType,
    required super.enType,
  });

  factory SpecieModel.fromJson(Map<String, dynamic> json) => SpecieModel(
        arType: json["arType"] ?? '',
        enType: json["enType"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "arType": arType,
        "enType": enType,
      };
}