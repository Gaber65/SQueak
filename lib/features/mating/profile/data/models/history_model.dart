

import 'package:squeak/features/pets/data/models/pet_model.dart';

import '../../domain/entities/history_entities.dart';

class HistoryModel extends HistoryEntity {
  const HistoryModel({
    required super.id,
    super.marriageDate,
    super.seperationDate,
    required super.isSeperated,
    required super.isPregnant,
    super.pregnantDate,
    required super.setAbaby,
    super.setbabyDate,
    required super.isMating,
    super.matingDate,
    super.pet,
    required super.isDiscover,
    super.discoverAt,
    super.partnerRateStar,
    super.partnerRateComment,
    required super.checkPregenantNotificationStatus,
    required super.isActive,
    required super.isDeleted,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      marriageDate: (json['marriageDate'] ?? ''),
      seperationDate: json['seperationDate'] != null
          ? (json['seperationDate'])
          : null,
      isSeperated: json['isSeperated'] ?? false,
      isPregnant: json['isPregnant'] ?? false,
      pregnantDate: (json['pregnantDate'] ?? ''),
      setAbaby: json['setAbaby'] ?? false,
      setbabyDate: (json['setbabyDate'] ?? ''),
      isMating: json['isMating'] ?? false,
      matingDate: (json['matingDate'] ?? ''),
      pet: json['pet'] != null ? PetData.fromJson(json['pet']) : null,
      isDiscover: json['isDiscover'] ?? false,
      discoverAt: (json['discoverAt'] ?? ''),
      partnerRateStar: json['partnerRateStar'],
      partnerRateComment: json['partnerRateComment'],
      checkPregenantNotificationStatus:
      json['checkPregenantNotificationSatues'] ?? false,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marriageDate': marriageDate,
      'seperationDate': seperationDate,
      'isSeperated': isSeperated,
      'isPregnant': isPregnant,
      'pregnantDate': pregnantDate,
      'setAbaby': setAbaby,
      'setbabyDate': setbabyDate,
      'isMating': isMating,
      'matingDate': matingDate,
      'pet': pet != null ? (pet as PetData).toJson() : null,
      'isDiscover': isDiscover,
      'discoverAt': discoverAt,
      'partnerRateStar': partnerRateStar,
      'partnerRateComment': partnerRateComment,
      'checkPregenantNotificationSatues': checkPregenantNotificationStatus,
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }
}
