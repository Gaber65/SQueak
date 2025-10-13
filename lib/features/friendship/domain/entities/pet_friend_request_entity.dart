import 'package:equatable/equatable.dart';
import 'package:squeak/features/friendship/domain/entities/friend_request_stats.dart';

class PetFriendRequestEntity extends Equatable {
  final String id;
  final String myPetId;
  final String friendPetId;

  final PetFriendStatus status;

  final DateTime? sendAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final DateTime? blockedAt;
  final String? blockedBy;
  final DateTime? canceledAt;
  final DateTime? unFriendAt;
  final String? unFriendBy;
  final DateTime? unBlockedAt;

  final String myPetName;
  final String myPetImage;
  final String myPetAge;

  final String friendPetName;
  final String friendPetImage;
  final String friendPetAge;

  final String friendName;

  const PetFriendRequestEntity({
    required this.id,
    required this.myPetId,
    required this.friendPetId,
    required this.status,
    this.sendAt,
    this.acceptedAt,
    this.rejectedAt,
    this.blockedAt,
    this.blockedBy,
    this.canceledAt,
    this.unFriendAt,
    this.unFriendBy,
    this.unBlockedAt,
    required this.myPetName,
    required this.myPetImage,
    required this.myPetAge,
    required this.friendPetName,
    required this.friendPetImage,
    required this.friendPetAge,
    required this.friendName,
  });

  @override
  List<Object?> get props => [
    id,
    myPetId,
    friendPetId,
    status,
    sendAt,
    acceptedAt,
    rejectedAt,
    blockedAt,
    blockedBy,
    canceledAt,
    unFriendAt,
    unFriendBy,
    unBlockedAt,
    myPetName,
    myPetImage,
    myPetAge,
    friendPetName,
    friendPetImage,
    friendPetAge,
    friendName,
  ];


}
