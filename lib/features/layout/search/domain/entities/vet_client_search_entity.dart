class VetSearchClientEntity {
  final String id;
  final String name;
  final int gender;
  final dynamic breedId;
  final String specieId;
  final String imageName;
  final dynamic colorId;
  final dynamic birthdate;
  final String clientId;
  final ClientEntity client;
  final dynamic color;
  final dynamic breed;
  final SpecieEntitySearch? specie;
  final bool addedInSqueakStatues;
  final String squeakPetId;

  VetSearchClientEntity({
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
}

class ClientEntity {
  final String name;
  final dynamic description;

  ClientEntity({required this.name, required this.description});
}

class SpecieEntitySearch {
  final String arType;
  final String enType;

  SpecieEntitySearch({required this.arType, required this.enType});
}

class DataVetEntity {
  final dynamic isRegistered;
  final dynamic isApplyInvitation;
  final dynamic vetICareId;
  final dynamic name;
  final dynamic phone;
  final dynamic countryId;
  final dynamic gender;
  final dynamic email;
  final dynamic clinicName;
  final dynamic clinicCode;
  final dynamic squeakUserId;

  DataVetEntity({
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
}
