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
