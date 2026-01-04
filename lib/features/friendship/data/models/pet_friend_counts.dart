import 'package:squeak/features/friendship/domain/entities/pet_friend_counts_entity.dart';

class FriendshipCountsModel extends FriendshipCounts {
  const FriendshipCountsModel({
    required super.blockList,
    required super.friendsCount,
    required super.requestsCount,
    required super.receivedRequestsCount,
    required super.suggestedFriendsCount,
  });

  factory FriendshipCountsModel.fromJson(Map<String, dynamic> json) {
    return FriendshipCountsModel(
      blockList: json['blocklistCount'] ?? 0,
      friendsCount: json['friendsCount'] ?? 0,
      requestsCount: json['friendShipRequestsCount'] ?? 0,
      receivedRequestsCount: json['receivedFriendShipRequestsCount'] ?? 0,
      suggestedFriendsCount: json['suggestedFriendsCount'] ?? 0,
    );
  }
}
