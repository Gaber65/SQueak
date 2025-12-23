import 'package:flutter/foundation.dart';
import 'package:squeak/features/mating/matingRequest/domain/entities/mating_request_entity.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';

class MatingRequestModel extends MatingRequestEntity {
  MatingRequestModel({
    required super.id,
    required super.fromPet,
    required super.toPet,
    required super.message,
    required super.status,
    required super.timestamp,
  });

  factory MatingRequestModel.fromJson(Map<String, dynamic> json) {
    final model = MatingRequestModel(
      id: json['id'],
      fromPet:
          json['userPet'] == null
              ? PetData.empty()
              : PetData.fromJson(json['userPet']),
      toPet:
          json['friendPet'] == null
              ? PetData.empty()
              : PetData.fromJson(json['friendPet']),
      message: json['message'] ?? '',
      status: RequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
      timestamp: json['createdAt'],
    );
    try {
      if (kDebugMode) {

      }
    } catch (_) {
      if (kDebugMode) {

      }
    }

    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromPet': (fromPet as PetData).toJson(),
      'toPet': (toPet as PetData).toJson(),
      'message': message,
      'status': status.name,
      'timestamp': timestamp,
    };
  }

  static List<MatingRequestModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => MatingRequestModel.fromJson(item)).toList();
  }
}
