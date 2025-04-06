class VetClientModel {
  String id;
  String name;
  int gender;
  dynamic breedId;
  String specieId;
  String imageName;
  dynamic colorId;
  dynamic birthdate;
  String clientId;
  Client client;
  dynamic color;
  dynamic breed;
  Specie? specie;
  bool addedInSqueakStatues;
  String squeakPetId;

  VetClientModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.breedId,
    required this.specieId,
    required this.imageName,
    required this.colorId,
    required this.birthdate,
    required this.clientId,
    required this.client,
    required this.color,
    required this.breed,
    required this.specie,
    required this.addedInSqueakStatues,
    required this.squeakPetId,
  });

  factory VetClientModel.fromJson(Map<String, dynamic> json) => VetClientModel(
    id: json["id"] ??'',
    name: json["name"] ??'',
    gender: json["gender" ??''],
    breedId: json["breedId"] ??'',
    specieId: json["specieId"] ??'',
    imageName: json["imageName"] ??'',
    colorId: json["colorId"] ??'',
    birthdate: json["birthdate"] ??'',
    clientId: json["clientId"] ??'',
    client: Client.fromJson(json["client"]),
    color: json["color"] ??'',
    breed: json["breed"] ??'',
    specie: json["specie"] == null ? null : Specie.fromJson(json["specie"]),
    addedInSqueakStatues: json["addedInSqueakStatues"],
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
    "client": client.toJson(),
    "color": color,
    "breed": breed,
    "specie": specie!.toJson(),
    "addedInSqueakStatues": addedInSqueakStatues,
    "squeakPetId": squeakPetId,
  };
}

class Client {
  String name;
  dynamic description;

  Client({
    required this.name,
    required this.description,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
  };
}

class Specie {
  String arType;
  String enType;

  Specie({
    required this.arType,
    required this.enType,
  });

  factory Specie.fromJson(Map<String, dynamic> json) => Specie(
    arType: json["arType"],
    enType: json["enType"],
  );

  Map<String, dynamic> toJson() => {
    "arType": arType,
    "enType": enType,
  };
}

class DataVet {
  dynamic isRegistered;
  dynamic isApplyInvitation;
  dynamic vetICareId;
  dynamic name;
  dynamic phone;
  dynamic countryId;
  dynamic gender;
  dynamic email;
  dynamic clinicName;
  dynamic clinicCode;
  dynamic squeakUserId;

  DataVet({
    required this.isRegistered,
    required this.isApplyInvitation,
    required this.vetICareId,
    required this.name,
    required this.phone,
    required this.countryId,
    required this.gender,
    required this.email,
    required this.clinicName,
    required this.clinicCode,
    required this.squeakUserId,
  });

  factory DataVet.fromJson(Map<String, dynamic> json) => DataVet(
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