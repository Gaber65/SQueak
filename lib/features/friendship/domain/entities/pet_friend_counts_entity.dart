import 'package:equatable/equatable.dart';
class FriendshipCounts extends Equatable {
  final int blockList;
  final int friendsCount;
  final int requestsCount;
  final int receivedRequestsCount;
  final int suggestedFriendsCount;

  const FriendshipCounts({
    required this.blockList,
    required this.friendsCount,
    required this.requestsCount,
    required this.receivedRequestsCount,
    required this.suggestedFriendsCount,
  });
  factory FriendshipCounts.fromJson(Map<String, dynamic> json) {
    return FriendshipCounts(
      blockList: json['blockList'] ?? 0,
      friendsCount: json['friendsCount'] ?? 0,
      requestsCount: json['requestsCount'] ?? 0,
      receivedRequestsCount: json['receivedRequestsCount'] ?? 0,
      suggestedFriendsCount: json['suggestedFriendsCount'] ?? 0,
    );
  }
  
  
  @override
  List<Object?> get props => [
        friendsCount,
        requestsCount,
        receivedRequestsCount,
        suggestedFriendsCount,
      ];
      
}
