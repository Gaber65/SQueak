import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class HistoryEntity extends Equatable {
  final String id;
  final String? marriageDate;
  final String? seperationDate;
  final String? pregnantDate;
  final String? setbabyDate;
  final String? matingDate;
  final String? discoverAt;

  final bool isSeperated;
  final bool isPregnant;
  final bool setAbaby;
  final bool isDiscover;
  final bool isMating;

  final PetEntities? pet;
  final int? partnerRateStar;
  final String? partnerRateComment;
  final bool checkPregenantNotificationStatus;
  final bool isActive;
  final bool isDeleted;

  const HistoryEntity({
    required this.id,
    this.marriageDate,
    this.seperationDate,
    required this.isSeperated,
    required this.isPregnant,
    this.pregnantDate,
    required this.setAbaby,
    this.setbabyDate,
    required this.isMating,
    this.matingDate,
    this.pet,
    required this.isDiscover,
    this.discoverAt,
    this.partnerRateStar,
    this.partnerRateComment,
    required this.checkPregenantNotificationStatus,
    required this.isActive,
    required this.isDeleted,
  });

  @override
  List<Object?> get props => [
    id,
    marriageDate,
    seperationDate,
    isSeperated,
    isPregnant,
    pregnantDate,
    setAbaby,
    setbabyDate,
    isMating,
    matingDate,
    pet,
    isDiscover,
    discoverAt,
    partnerRateStar,
    partnerRateComment,
    checkPregenantNotificationStatus,
    isActive,
    isDeleted,
  ];

  HistoryStatus get currentStatus {
    if (isMating) return HistoryStatus.mating;
    if (isPregnant) return HistoryStatus.pregnant;
    if (setAbaby) return HistoryStatus.hasBaby;
    if (isSeperated) return HistoryStatus.separated;
    if (isDiscover) return HistoryStatus.discovered;
    return HistoryStatus.notAvailable;
  }

  String? get currentStatusDate {
    switch (currentStatus) {
      case HistoryStatus.mating:
        return matingDate;
      case HistoryStatus.pregnant:
        return pregnantDate;
      case HistoryStatus.hasBaby:
        return setbabyDate;
      case HistoryStatus.separated:
        return seperationDate;
      case HistoryStatus.discovered:
        return discoverAt;
      default:
        return null;
    }
  }
}

enum HistoryStatus {
  mating,
  pregnant,
  hasBaby,
  separated,
  discovered,
  available,
  notAvailable,
}

extension HistoryStatusExtension on HistoryStatus {
  String get displayName {
    switch (this) {
      case HistoryStatus.notAvailable:
        return 'Not Available';
      case HistoryStatus.available:
        return 'Available';
      case HistoryStatus.mating:
        return 'Mating';
      case HistoryStatus.pregnant:
        return 'Pregnant';
      case HistoryStatus.hasBaby:
        return 'Has Baby';
      case HistoryStatus.separated:
        return 'Separated';
      case HistoryStatus.discovered:
        return 'Discovered';
    }
  }

  Color get color {
    switch (this) {
      case HistoryStatus.available:
        return Colors.green;
      case HistoryStatus.mating:
        return Colors.blue;
      case HistoryStatus.pregnant:
        return Colors.purple;
      case HistoryStatus.hasBaby:
        return Colors.orange;
      case HistoryStatus.separated:
        return Colors.red;
      case HistoryStatus.discovered:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case HistoryStatus.available:
        return Icons.favorite;
      case HistoryStatus.mating:
        return Icons.favorite;
      case HistoryStatus.pregnant:
        return Icons.pregnant_woman;
      case HistoryStatus.hasBaby:
        return Icons.child_friendly;
      case HistoryStatus.separated:
        return Icons.cancel;
      case HistoryStatus.discovered:
        return Icons.search;
      default:
        return Icons.info_outline;
    }
  }
}

List<Map<String, dynamic>> statusesAlertToUpdateHistory(s) => [
  {
    'status': HistoryStatus.separated,
    'title': s.previously_mated,
    'description': s.previously_mated_desc,
  },
  {
    'status': HistoryStatus.pregnant,
    'title': s.pregnant,
    'description': s.pregnant_desc,
  },
  {
    'status': HistoryStatus.hasBaby,
    'title': s.has_set_its_baby,
    'description': s.has_set_its_baby_desc,
  },
];

List<Map<String, dynamic>> statusesAlertToUpdateProfile(s) => [
  {
    'status': HistoryStatus.notAvailable,
    'title': s.single,
    'description': s.single_desc,
  },
  {
    'status': HistoryStatus.available,
    'title': s.available_for_mating,
    'description': s.available_for_mating_desc,
  },
];
