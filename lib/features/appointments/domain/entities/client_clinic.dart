import 'package:equatable/equatable.dart';

class PetClinic extends Equatable {
  final String petId;
  final String petName;
  final String petSqueakId;
  final String clientId;
  final int petGender;
  bool isSelected = false;
  PetClinic({
    required this.petId,
    required this.petSqueakId,
    required this.petName,
    required this.clientId,
    required this.petGender,
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [petId, petSqueakId, petName, clientId, petGender];
}
