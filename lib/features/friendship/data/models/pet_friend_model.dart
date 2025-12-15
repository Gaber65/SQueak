import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';

import '../../domain/entities/friend_request_stats.dart';

class PetFriendModel extends PetFriendRequestEntity {
  const PetFriendModel({
    required super.id,
    required super.myPetId,
    required super.friendPetId,
    required super.status,
    super.sendAt,
    super.acceptedAt,
    super.rejectedAt,
    super.blockedAt,
    super.blockedBy,
    super.canceledAt,
    super.unFriendAt,
    super.unFriendBy,
    super.unBlockedAt,
    required super.myPetName,
    required super.myPetImage,
    required super.myPetAge,
    required super.friendPetName,
    required super.friendPetImage,
    required super.friendPetAge,
    required super.friendName,
  });

  factory PetFriendModel.fromJson(Map<String, dynamic> json) {
    return PetFriendModel(
      id: json['id'],
      myPetId: json['myPetId'],
      friendPetId: json['friendPetId'],
      status: PetFriendStatus.values.firstWhere(
        (e) => e.toString() == 'PetFriendStatus.${json['status']}',
        orElse: () => PetFriendStatus.none,
      ),
      sendAt: json['sendAt'] != null ? DateTime.parse(json['sendAt']) : null,
      acceptedAt:
          json['acceptedAt'] != null
              ? DateTime.parse(json['acceptedAt'])
              : null,
      rejectedAt:
          json['rejectedAt'] != null
              ? DateTime.parse(json['rejectedAt'])
              : null,
      blockedAt:
          json['blockedAt'] != null ? DateTime.parse(json['blockedAt']) : null,
      blockedBy: json['blockedBy'],
      canceledAt:
          json['canceledAt'] != null
              ? DateTime.parse(json['canceledAt'])
              : null,
      unFriendAt:
          json['unFriendAt'] != null
              ? DateTime.parse(json['unFriendAt'])
              : null,
      unFriendBy: json['unFriendBy'],
      unBlockedAt:
          json['unBlockedAt'] != null
              ? DateTime.parse(json['unBlockedAt'])
              : null,
      myPetName: json['myPetName'],
      myPetImage: json['myPetImage'],
      myPetAge: json['myPetAge'],
      friendPetName: json['friendPetName'],
      friendPetImage: json['friendPetImage'],
      friendPetAge: json['friendPetAge'],
      friendName: json['friendName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'myPetId': myPetId,
      'friendPetId': friendPetId,
      'status': status.name,
      'sendAt': sendAt?.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'blockedAt': blockedAt?.toIso8601String(),
      'blockedBy': blockedBy,
      'canceledAt': canceledAt?.toIso8601String(),
      'unFriendAt': unFriendAt?.toIso8601String(),
      'unFriendBy': unFriendBy,
      'unBlockedAt': unBlockedAt?.toIso8601String(),
      'myPetName': myPetName,
      'myPetImage': myPetImage,
      'myPetAge': myPetAge,
      'friendPetName': friendPetName,
      'friendPetImage': friendPetImage,
      'friendPetAge': friendPetAge,
      'friendName': friendName,
    };
  }
}
