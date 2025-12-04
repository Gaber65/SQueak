import '../../domain/entities/react_entities.dart';

class ReactionPetModel extends ReactionPet {
  const ReactionPetModel({required super.petName, required super.imageName});

  factory ReactionPetModel.fromJson(Map<String, dynamic> json) {
    return ReactionPetModel(
      petName: json['petName'] ?? '',
      imageName: json['imageName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {"petName": petName, "imageName": imageName};
}

class ReactionOwnerModel extends ReactionOwner {
  const ReactionOwnerModel({required super.fullName, required super.imageName});

  factory ReactionOwnerModel.fromJson(Map<String, dynamic> json) {
    return ReactionOwnerModel(
      fullName: json['fullName'] ?? '',
      imageName: json['imageName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "imageName": imageName,
  };
}

class ReactionItemModel extends ReactionItem {
  const ReactionItemModel({
    required super.reactType,
    required super.postId,
    required super.ownerId,
    required super.owner,
    required super.petId,
    required super.pet,
  });

  factory ReactionItemModel.fromJson(Map<String, dynamic> json) {
    return ReactionItemModel(
      reactType: json['reactType'],
      postId: json['postId']?? '',
      ownerId: json['ownerId']?? '',
      owner: json['owner'] != null ? ReactionOwnerModel.fromJson(json['owner']) : null,
      petId: json['petId'] ?? '',
      pet: json['pet'] != null ? ReactionPetModel.fromJson(json['pet']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "reactType": reactType,
    "postId": postId,
    "ownerId": ownerId,
    "owner": owner,
    "petId": petId,
    "pet": pet is ReactionPetModel ? (pet as ReactionPetModel).toJson() : null,
  };
}

class ReactionSummaryModel extends ReactionSummary {
  const ReactionSummaryModel({
    required super.happyReaction,
    required super.sadReaction,
    required super.angryReaction,
    required super.loveReaction,
    required super.likeReaction,
    required super.happyCount,
    required super.sadCount,
    required super.loveCount,
    required super.angryCount,
    required super.likeCount,
    required super.totalReactCount,
  });

  factory ReactionSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReactionSummaryModel(
      happyReaction:
          (json['happyReaction'] as List)
              .map((e) => ReactionItemModel.fromJson(e))
              .toList(),
      sadReaction:
          (json['sadReaction'] as List)
              .map((e) => ReactionItemModel.fromJson(e))
              .toList(),
      angryReaction:
          (json['angryReaction'] as List)
              .map((e) => ReactionItemModel.fromJson(e))
              .toList(),
      loveReaction:
          (json['loveReaction'] as List)
              .map((e) => ReactionItemModel.fromJson(e))
              .toList(),
      likeReaction:
          (json['likeReaction'] as List)
              .map((e) => ReactionItemModel.fromJson(e))
              .toList(),
      happyCount: json['happyCount'],
      sadCount: json['sadCount'],
      loveCount: json['loveCount'],
      angryCount: json['angryCount'],
      likeCount: json['likeCount'],
      totalReactCount: json['totalReactCount'],
    );
  }

  Map<String, dynamic> toJson() => {
    "happyReaction":
        happyReaction.map((e) => (e as ReactionItemModel).toJson()).toList(),
    "sadReaction":
        sadReaction.map((e) => (e as ReactionItemModel).toJson()).toList(),
    "angryReaction":
        angryReaction.map((e) => (e as ReactionItemModel).toJson()).toList(),
    "loveReaction":
        loveReaction.map((e) => (e as ReactionItemModel).toJson()).toList(),
    "likeReaction":
        likeReaction.map((e) => (e as ReactionItemModel).toJson()).toList(),
    "happyCount": happyCount,
    "sadCount": sadCount,
    "loveCount": loveCount,
    "angryCount": angryCount,
    "likeCount": likeCount,
    "totalReactCount": totalReactCount,
  };
}


class ReactionActionResultModel extends ReactionActionResult {
  const ReactionActionResultModel({
    required super.isAdded,
    required super.happyCount,
    required super.sadCount,
    required super.loveCount,
    required super.angryCount,
    required super.likeCount,
  });

  factory ReactionActionResultModel.fromJson(Map<String, dynamic> json) {
    return ReactionActionResultModel(
      isAdded: json['isAdded'] ?? false,
      happyCount: json['happyCount'] ?? 0,
      sadCount: json['sadCount'] ?? 0,
      loveCount: json['loveCount'] ?? 0,
      angryCount: json['angryCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "isAdded": isAdded,
    "happyCount": happyCount,
    "sadCount": sadCount,
    "loveCount": loveCount,
    "angryCount": angryCount,
    "likeCount": likeCount,
  };
}