import 'package:flutter/material.dart';

abstract class PetMatingEntity {
  String get id;
  String get name;
  String get breed;
  String get gender;
  String get age;
  String? get description;
  String get profilePicture;
  PetMatingStatus get status;
  String? get passportNumber;
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
      case PetMatingStatus.single: return 'Single';
      case PetMatingStatus.availableForMating: return 'Available for Mating';
      case PetMatingStatus.onMating: return 'On Mating';
      case PetMatingStatus.previouslyMated: return 'Previously Mated';
      case PetMatingStatus.pregnant: return 'Pregnant';
      case PetMatingStatus.hasSetItsBaby: return 'Has Set Its Baby';
      case PetMatingStatus.divorced: return 'Divorced';
    }
  }

  Color get color {
    switch (this) {
      case PetMatingStatus.single: return Colors.grey;
      case PetMatingStatus.availableForMating: return Colors.green;
      case PetMatingStatus.onMating: return Colors.blue;
      case PetMatingStatus.previouslyMated: return Colors.grey;
      case PetMatingStatus.pregnant: return Colors.purple;
      case PetMatingStatus.hasSetItsBaby: return Colors.pink;
      case PetMatingStatus.divorced: return Colors.orange;
    }
  }
}