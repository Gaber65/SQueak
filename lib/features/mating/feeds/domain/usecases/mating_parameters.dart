import '../entities/pet_mating_entity.dart';

class GetPetsParameters {
  final PetMatingStatus? status;

  const GetPetsParameters({this.status});
}

class SendMatingRequestParameters {
  final String targetPetId;
  final String message;
  final String senderPetId;

  const SendMatingRequestParameters({
    required this.targetPetId,
    required this.message,
    required this.senderPetId,
  });
}

class UpdatePetStatusParameters {
  final String petId;
  final PetMatingStatus status;

  const UpdatePetStatusParameters({
    required this.petId,
    required this.status,
  });
}