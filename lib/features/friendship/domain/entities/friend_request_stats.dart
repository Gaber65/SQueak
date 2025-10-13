


enum PetFriendStatus {
  none,
  friend,
  suggested,
  pendingReceived,
  pendingSent,
}


enum FriendshipStatus {
  none,
  accepted,
  rejected;


  static String toApiValue(FriendshipStatus status) {
    switch (status) {
      case FriendshipStatus.none:
        return "none";
      case FriendshipStatus.accepted:
        return "accepted";
      case FriendshipStatus.rejected:
        return "rejected";
    }
  }
}
