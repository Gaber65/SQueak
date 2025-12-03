import '../../presentation/animated_reaction/reaction_data.dart';
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

int getReactionType(int? reactionIndex) {
  if (reactionIndex == null) {
    return ReactType.none.index;
  } else if (reactionIndex == 0) {
    return ReactType.like.index;
  } else if (reactionIndex == 1) {
    return ReactType.love.index;
  } else if (reactionIndex == 2) {
    return ReactType.happy.index;
  } else if (reactionIndex == 3) {
    return ReactType.sad.index;
  } else if (reactionIndex == 4) {
    return ReactType.angry.index;
  }
  return 0;
}

int getReactionTypeInvers(int? reactionIndex) {
  if (reactionIndex == null) {
    return ReactType.none.index;
  } else if (reactionIndex == 5) {
    return ReactType.like.index;
  } else if (reactionIndex == 3) {
    return ReactType.love.index;
  } else if (reactionIndex == 1) {
    return ReactType.happy.index;
  } else if (reactionIndex == 2) {
    return ReactType.sad.index;
  } else if (reactionIndex == 4) {
    return ReactType.angry.index;
  }
  return 0;
}

String getReactionIcon(ReactType type) {
  switch (type) {
    case ReactType.like:
      return ReactionData.facebookReactionIcon[0];
    case ReactType.love:
      return ReactionData.facebookReactionIcon[1];
    case ReactType.happy:
      return ReactionData.facebookReactionIcon[2];
    case ReactType.sad:
      return ReactionData.facebookReactionIcon[3];
    case ReactType.angry:
      return ReactionData.facebookReactionIcon[4];
    default:
      return ReactionData.facebookReactionIcon[0];
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
