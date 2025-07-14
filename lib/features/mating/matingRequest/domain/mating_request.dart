import 'package:flutter/material.dart';
import 'package:squeak/features/mating/feeds/domain/entities/pet_mating_model.dart';

class MatingRequest {
  final String id;
  final PetMating fromPet;
  final PetMating toPet;
  final String message;
  final RequestStatus status;
  final DateTime timestamp;

  MatingRequest({
    required this.id,
    required this.fromPet,
    required this.toPet,
    required this.message,
    required this.status,
    required this.timestamp,
  });

  MatingRequest copyWith({
    String? id,
    PetMating? fromPet,
    PetMating? toPet,
    String? message,
    RequestStatus? status,
    DateTime? timestamp,
  }) {
    return MatingRequest(
      id: id ?? this.id,
      fromPet: fromPet ?? this.fromPet,
      toPet: toPet ?? this.toPet,
      message: message ?? this.message,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

 static List<MatingRequest> dummyMatingRequests = [
    MatingRequest(
      id: 'req-001',
      fromPet: PetMating.availablePets[0], // Bella
      toPet: PetMating.availablePets[1],   // Max
      message: 'Hi! Bella would love to meet Max. Let us know if you’re interested!',
      status: RequestStatus.pending,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    MatingRequest(
      id: 'req-002',
      fromPet: PetMating.availablePets[1], // Max
      toPet: PetMating.availablePets[2],   // Luna
      message: 'Max is looking for a beautiful partner like Luna.',
      status: RequestStatus.accepted,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    MatingRequest(
      id: 'req-003',
      fromPet: PetMating.availablePets[2], // Luna
      toPet: PetMating.availablePets[0],   // Bella
      message: 'Luna wants to be friends with Bella first.',
      status: RequestStatus.rejected,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

enum RequestStatus {
  pending,
  accepted,
  rejected,
}

extension RequestStatusExtension on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.rejected:
        return 'Rejected';
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
    }
  }
}
