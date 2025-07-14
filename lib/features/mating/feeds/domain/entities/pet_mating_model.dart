import 'package:flutter/material.dart';

class PetMating {
  final String id;
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String? description;
  final String profilePicture;
  final PetMatingStatus status;
  final String? passportNumber;

  PetMating({
    required this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    this.description,
    required this.profilePicture,
    required this.status,
    this.passportNumber,
  });

  PetMating copyWith({
    String? id,
    String? name,
    String? breed,
    String? gender,
    String? age,
    String? description,
    String? profilePicture,
    PetMatingStatus? status,
    String? passportNumber,
  }) {
    return PetMating(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      description: description ?? this.description,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      passportNumber: passportNumber ?? this.passportNumber,
    );
  }
  static List<PetMating> availablePets = [
    PetMating(
      id: 'available-1',
      name: 'Bella',
      breed: 'Golden Retriever',
      gender: 'Female',
      age: '2 years',
      description: 'Friendly and loves to play fetch!',
      profilePicture: 'assets/images/bella.jpg',
      status: PetMatingStatus.availableForMating,
    ),
    PetMating(
      id: 'available-2',
      name: 'Max',
      breed: 'German Shepherd',
      gender: 'Male',
      age: '3 years',
      description: 'Very gentle and well-trained',
      profilePicture: 'assets/images/max.jpg',
      status: PetMatingStatus.availableForMating,
    ),
    PetMating(
      id: 'available-3',
      name: 'Luna',
      breed: 'Persian Cat',
      gender: 'Female',
      age: '1.5 years',
      description: 'Sweet and affectionate',
      profilePicture: 'assets/images/luna.jpg',
      status: PetMatingStatus.availableForMating,
    ),
  ];

}

enum PetMatingStatus {
  single,
  availableForMating,
  onMating,
  previouslyMated,
  pregnant,
  hasSetItsBaby,
  divorced,
}

extension PetMatingStatusExtension on PetMatingStatus {
  String get displayName {
    switch (this) {
      case PetMatingStatus.single:
        return 'Single';
      case PetMatingStatus.availableForMating:
        return 'Available for Mating';
      case PetMatingStatus.onMating:
        return 'On Mating';
      case PetMatingStatus.previouslyMated:
        return 'Previously Mated';
      case PetMatingStatus.pregnant:
        return 'Pregnant';
      case PetMatingStatus.hasSetItsBaby:
        return 'Has Set Its Baby';
      case PetMatingStatus.divorced:
        return 'Divorced';
    }
  }

  Color get color {
    switch (this) {
      case PetMatingStatus.single:
        return Colors.grey;
      case PetMatingStatus.availableForMating:
        return Colors.green;
      case PetMatingStatus.onMating:
        return Colors.blue;
      case PetMatingStatus.previouslyMated:
        return Colors.grey;
      case PetMatingStatus.pregnant:
        return Colors.purple;
      case PetMatingStatus.hasSetItsBaby:
        return Colors.pink;
      case PetMatingStatus.divorced:
        return Colors.orange;
    }
  }
}
