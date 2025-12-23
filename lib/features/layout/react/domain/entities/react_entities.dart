import '../repo/base_react_repo.dart';

class ReactionPet {
  final String petName;
  final String imageName;

  const ReactionPet({required this.petName, required this.imageName});
}

class ReactionOwner {
  final String fullName;
  final String imageName;

  const ReactionOwner({required this.fullName, required this.imageName});
}

class ReactionItem {
  final int reactType;
  final String postId;
  final String ownerId;
  final ReactionOwner? owner;
  final String petId;
  final ReactionPet? pet;

  const ReactionItem({
    required this.reactType,
    required this.postId,
    required this.ownerId,
    required this.owner,
    required this.petId,
    required this.pet,
  });
}





// In your react_entities.dart or wherever getReactionIcon is defined
String getReactionIcon(ReactType type) {
  // Map ReactType to asset paths
  switch (type) {
    case ReactType.happy:
      return "assets/react/cat/haha.jpg";  // or .gif depending on what you need
    case ReactType.sad:
      return "assets/react/cat/sad.jpg";
    case ReactType.love:
      return "assets/react/cat/love.jpg";
    case ReactType.angry:
      return "assets/react/cat/angry.jpg";
    case ReactType.like:
      return "assets/react/cat/like_fill_cat.jpg";
    case ReactType.none:
      return "assets/react/cat/like_gap_cat.jpg"; // Default icon for no reaction
  }
}

class ReactionSummary {
  final List<ReactionItem> happyReaction;
  final List<ReactionItem> sadReaction;
  final List<ReactionItem> angryReaction;
  final List<ReactionItem> loveReaction;
  final List<ReactionItem> likeReaction;

  final int happyCount;
  final int sadCount;
  final int loveCount;
  final int angryCount;
  final int likeCount;
  final int totalReactCount;

  const ReactionSummary({
    required this.happyReaction,
    required this.sadReaction,
    required this.angryReaction,
    required this.loveReaction,
    required this.likeReaction,
    required this.happyCount,
    required this.sadCount,
    required this.loveCount,
    required this.angryCount,
    required this.likeCount,
    required this.totalReactCount,
  });
}

class ReactionActionResult {
  final bool isAdded;
  final int happyCount;
  final int sadCount;
  final int loveCount;
  final int angryCount;
  final int likeCount;

  const ReactionActionResult({
    required this.isAdded,
    required this.happyCount,
    required this.sadCount,
    required this.loveCount,
    required this.angryCount,
    required this.likeCount,
  });

  static ReactionActionResult empty() {
    return ReactionActionResult(
      isAdded: false,
      happyCount: 0,
      sadCount: 0,
      loveCount: 0,
      angryCount: 0,
      likeCount: 0,
    );
  }
}
