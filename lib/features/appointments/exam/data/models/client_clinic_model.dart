import '../../domain/entities/client_clinic.dart';

class PetClinicModel extends PetClinic {
  PetClinicModel({
    required super.petId,
    required super.petSqueakId,
    required super.petName,
    required super.clientId,
    required super.petGender,
  });

  factory PetClinicModel.fromJson(Map<String, dynamic> json) {
    return PetClinicModel(
      petId: json['id'],
      petName: json['name'],
      petSqueakId: json['squeakPetId'] ?? '',
      petGender: json['gender'],
      clientId: json['clientId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': petId,
      'name': petName,
      'squeakPetId': petSqueakId,
      'gender': petGender,
      'clientId': clientId,
    };
  }
}
