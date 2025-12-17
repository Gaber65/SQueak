import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

class HistoryEntity extends Equatable {
  final String id;
  final String? marriageDate;
  final String? separationDate; // Fixed typo: seperationDate -> separationDate
  final String? pregnantDate;
  final String? setBabyDate; // Fixed typo: setbabyDate -> setBabyDate
  final String? matingDate;
  final String? discoverAt;

  final bool isSeparated; // Fixed typo: isSeperated -> isSeparated
  final bool isPregnant;
  final bool setABaby; // Fixed typo: setAbaby -> setABaby
  final bool isDiscover;
  final bool isMating;

  final PetEntities? pet;
  final int? partnerRateStar;
  final String? partnerRateComment;
  final bool
  checkPregnantNotificationStatus; // Fixed typo: checkPregenantNotificationStatus
  final bool isActive;
  final bool isDeleted;

  const HistoryEntity({
    required this.id,
    this.marriageDate,
    this.separationDate,
    required this.isSeparated,
    required this.isPregnant,
    this.pregnantDate,
    required this.setABaby,
    this.setBabyDate,
    required this.isMating,
    this.matingDate,
    this.pet,
    required this.isDiscover,
    this.discoverAt,
    this.partnerRateStar,
    this.partnerRateComment,
    required this.checkPregnantNotificationStatus,
    required this.isActive,
    required this.isDeleted,
  });

  @override
  List<Object?> get props => [
    id,
    marriageDate,
    separationDate,
    isSeparated,
    isPregnant,
    pregnantDate,
    setABaby,
    setBabyDate,
    isMating,
    matingDate,
    pet,
    isDiscover,
    discoverAt,
    partnerRateStar,
    partnerRateComment,
    checkPregnantNotificationStatus,
    isActive,
    isDeleted,
  ];

  HistoryStatus get currentStatus {
    if (isMating) return HistoryStatus.mating;
    if (isPregnant) return HistoryStatus.pregnant;
    if (setABaby) return HistoryStatus.hasBaby;
    if (isSeparated) return HistoryStatus.separated;
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
        return setBabyDate;
      case HistoryStatus.separated:
        return separationDate;
      case HistoryStatus.discovered:
        return discoverAt;
      default:
        return null;
    }
  }
}

enum HistoryStatus {
  single,
  availableForMating,
  married,
  mating,
  pregnant,
  hasBaby,
  separated, // Added missing value
  discovered, // Added missing value
  notAvailable,
  inMatingProcess,
}

extension HistoryStatusExtension on HistoryStatus {
  int get toApiValue {
    switch (this) {
      case HistoryStatus.single:
        return 0;
      case HistoryStatus.availableForMating:
        return 1;
      case HistoryStatus.married:
        return 2;
      case HistoryStatus.discovered: // Divorced
        return 3;
      case HistoryStatus.pregnant:
        return 4;
      case HistoryStatus.hasBaby:
        return 5;
      case HistoryStatus.notAvailable:
        return 6;
      case HistoryStatus.inMatingProcess:
        return 7;
      case HistoryStatus.mating:
        return 7; // Same as InMatingProcess
      case HistoryStatus.separated:
        return 6; // Same as NotAvailable
    }
  }

  String get displayName {
    switch (this) {
      case HistoryStatus.single:
        return 'Single';
      case HistoryStatus.availableForMating:
        return 'AvailableForMating';
      case HistoryStatus.married:
        return 'Married';
      // case HistoryStatus.divorced:
      //   return 'Divorced';
      case HistoryStatus.mating:
        return 'Mating';
      case HistoryStatus.pregnant:
        return 'Pregnant';
      case HistoryStatus.hasBaby:
        return 'HasBaby';
      case HistoryStatus.separated:
        return 'Separated';
      case HistoryStatus.discovered:
        return 'Discovered';
      case HistoryStatus.notAvailable:
        return 'NotAvailable';
      case HistoryStatus.inMatingProcess:
        return 'InMatingProcess';
    }
  }

  Color get color {
    switch (this) {
      case HistoryStatus.availableForMating:
        // case HistoryStatus.divorced:
        return Colors.green;
      case HistoryStatus.mating:
      case HistoryStatus.inMatingProcess:
        return Colors.blue;
      case HistoryStatus.pregnant:
        return Colors.purple;
      case HistoryStatus.hasBaby:
        return Colors.orange;
      case HistoryStatus.notAvailable:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case HistoryStatus.availableForMating:
        return Icons.favorite;
      case HistoryStatus.mating:
      case HistoryStatus.inMatingProcess:
        return Icons.favorite;
      case HistoryStatus.pregnant:
        return Icons.pregnant_woman;
      case HistoryStatus.hasBaby:
        return Icons.child_friendly;
      case HistoryStatus.separated:
      // case HistoryStatus.divorced:
      //   return Icons.cancel;
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
    'status': HistoryStatus.single,
    'title': s.single,
    'description': s.single_desc,
  },
  {
    'status': HistoryStatus.availableForMating,
    'title': s.available_for_mating,
    'description': s.available_for_mating_desc,
  },
  {
    'status': HistoryStatus.mating,
    'title': s.on_mating,
    'description': s.on_mating_desc,
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
  {
    'status': HistoryStatus.discovered,
    'title': s.divorced,
    'description': s.divorced_desc,
  },
  {
    'status': HistoryStatus.notAvailable,
    'title': s.not_available,
    'description': s.not_available_desc,
  },
];
