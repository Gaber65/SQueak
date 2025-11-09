import 'package:squeak/features/friendship/domain/entities/friend_request_stats.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

abstract class PetFriendsState {}

class FriendsInitial extends PetFriendsState {}

class FriendsLoaded extends PetFriendsState {
  final List<PetEntities> friends;
  final List<PetEntities> suggestedFriends;
  final List<PetEntities> pendingRequests;
  final List<PetEntities> sentRequests;
  final int selectedTab;

  FriendsLoaded({
    required this.friends,
    required this.suggestedFriends,
    required this.pendingRequests,
    required this.sentRequests,
    this.selectedTab = 0,
  });

  FriendsLoaded copyWith({
    List<PetEntities>? friends,
    List<PetEntities>? suggestedFriends,
    List<PetEntities>? pendingRequests,
    List<PetEntities>? sentRequests,
    int? selectedTab,
  }) {
    return FriendsLoaded(
      friends: friends ?? this.friends,
      suggestedFriends: suggestedFriends ?? this.suggestedFriends,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      sentRequests: sentRequests ?? this.sentRequests,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class FriendsLoading extends PetFriendsState {}

class SuggestedFriendsLoading extends PetFriendsState {}

class SuggestedFriendsLoaded extends PetFriendsState {
  final List<PetEntities> friends;
  SuggestedFriendsLoaded({required this.friends});
}
class ReceivedFriendsLoaded extends PetFriendsState {
  final List<PetFriendRequestEntity> friends;
  ReceivedFriendsLoaded({required this.friends});
}

class SuggestedFriendsError extends PetFriendsState {}

class FriendRequestSending extends PetFriendsState {}

class FriendRequestSent extends PetFriendsState {
  final PetEntities pet;
  FriendRequestSent({required this.pet});
}

class FriendRequestFailed extends PetFriendsState {}

class FriendRequestCancelling extends PetFriendsState {}

class FriendRequestCancelled extends PetFriendsState {
  final PetEntities pet;
  FriendRequestCancelled({required this.pet});
}

class FriendRequestCancelFailed extends PetFriendsState {}

class FriendRequestUpdating extends PetFriendsState {}

class FriendRequestUpdated extends PetFriendsState {
  final PetFriendRequestEntity pet;
  final FriendshipStatus status;
  FriendRequestUpdated({required this.pet, required this.status});
}

class FriendRequestUpdateFailed extends PetFriendsState {}

class FriendUnblocking extends PetFriendsState {}

class FriendUnblocked extends PetFriendsState {
  final PetEntities pet;
  FriendUnblocked({required this.pet});
}

class FriendUnblockFailed extends PetFriendsState {}

class FriendsLoadSuccess extends PetFriendsState {
  final List<PetEntities> friends;
  FriendsLoadSuccess({required this.friends});
}
class FriendsLoadEmpty extends PetFriendsState {}
class FriendsLoadFailed extends PetFriendsState {
  final String message;
  FriendsLoadFailed({required this.message});
}


class ChangeTab extends PetFriendsState {
  final int tabIndex;

  ChangeTab({required this.tabIndex});
}

class ChangeRequestFilter extends PetFriendsState {
  final String filter; // 'sent' or 'received'

  ChangeRequestFilter({required this.filter});
}

// Chat states
class ChatsLoading extends PetFriendsState {}

class ChatsLoaded extends PetFriendsState {
  final List<ChatEntity> chats;
  ChatsLoaded({required this.chats});
}

class ChatsLoadFailed extends PetFriendsState {
  final String message;
  ChatsLoadFailed({required this.message});
}

// Blocked friends states
class BlockedFriendsLoading extends PetFriendsState {}

class BlockedFriendsLoaded extends PetFriendsState {
  final List<PetFriendRequestEntity> blockedFriends;
  BlockedFriendsLoaded({required this.blockedFriends});
}

class BlockedFriendsLoadFailed extends PetFriendsState {
  final String message;
  BlockedFriendsLoadFailed({required this.message});
}
// Cancel friendship 
class DeleteFriendShipLoading extends PetFriendsState {}
class DeleteFriendShipFailed extends PetFriendsState {
  final String message;
  DeleteFriendShipFailed({required this.message});
}
class DeleteFriendShipSuccess extends PetFriendsState {}
// Block friendship
class BlockFriendshipLoading extends PetFriendsState {}
class BlockFriendshipFailed extends PetFriendsState {
  final String message;
  BlockFriendshipFailed({required this.message});
}
class BlockFriendshipSuccess extends PetFriendsState {}
// UnBlock friendship
class UnBlockFriendshipLoading extends PetFriendsState {}
class UnBlockFriendshipFailed extends PetFriendsState {
  final String message;
  UnBlockFriendshipFailed({required this.message});
}
class UnBlockFriendshipSuccess extends PetFriendsState {}