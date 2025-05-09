class ClientClinicModel {
  final String petId;
  final String petName;
  final String petSqueakId;
  final String clientId;
  final int petGender;

  ClientClinicModel({
    required this.petId,
    required this.petSqueakId,
    required this.petName,
    required this.clientId,
    required this.petGender,
  });

  factory ClientClinicModel.fromJson(Map<String, dynamic> json) {
    return ClientClinicModel(
      petId: json['id'],
      petName: json['name'],
      petSqueakId: json['squeakPetId'] ?? '',
      petGender: json['gender'],
      clientId: json['clientId'],
    );
  }
}
