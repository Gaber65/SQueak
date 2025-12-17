import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:flutter/material.dart';

enum RequestStatus { pending, accepted, rejected, onMating, canceled }

extension RequestStatusExtension on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return "Pending";
      case RequestStatus.accepted:
        return "Accepted";
      case RequestStatus.rejected:
        return "Rejected";
      case RequestStatus.onMating:
        return "On Mating";
      case RequestStatus.canceled:
        return "Canceled";
    }
  }

  Color get color {
    switch (this) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.accepted:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.onMating:
        return Colors.blue;
      case RequestStatus.canceled:
        return Colors.grey;
    }
  }
}

class MatingRequestEntity {
  final String id;
  final PetEntities fromPet;
  final PetEntities toPet;
  final String message;
  RequestStatus status;
  final String timestamp;

  MatingRequestEntity({
    required this.id,
    required this.fromPet,
    required this.toPet,
    required this.message,
    required this.status,
    required this.timestamp,
  });
}
