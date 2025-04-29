import 'package:equatable/equatable.dart';

class VetClient extends Equatable {
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
  final SpecieEntity? specie;
  final bool addedInSqueakStatues;
  final String squeakPetId;

  const VetClient({
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

  @override
  List<Object?> get props => [
        id,
        name,
        gender,
        breedId,
        specieId,
        imageName,
        colorId,
        birthdate,
        clientId,
        client,
        color,
        breed,
        specie,
        addedInSqueakStatues,
        squeakPetId,
      ];
}

class ClientEntity extends Equatable {
  final String name;
  final dynamic description;

  const ClientEntity({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

class SpecieEntity extends Equatable {
  final String arType;
  final String enType;

  const SpecieEntity({
    required this.arType,
    required this.enType,
  });

  @override
  List<Object> get props => [arType, enType];
}