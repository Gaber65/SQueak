import '../../domain/entities/story_reaction_entity.dart';

class StoryReactionModel extends StoryReactionEntity {
  const StoryReactionModel({
    required super.id,
    required super.userStoryId,
    required super.petId,
    required super.applicationUserId,
    required super.reactType,
    required super.userName,
    required super.userImage,
    required super.petName,
    required super.petImage,
    required super.reactedAt,
    super.viewAt,
  });

  factory StoryReactionModel.fromJson(Map<String, dynamic> json) {
    return StoryReactionModel(
      id: json['id'] ?? '',
      userStoryId: json['userStoryId'] ?? '',
      petId: json['petId'],
      applicationUserId: json['applicationUserId'],
      reactType: json['reactType'] ?? 0,
      userName: json['userName'],
      userImage: json['userImage'],
      petName: json['petname'], // note lowercase
      petImage: json['petImage'],
      reactedAt: DateTime.parse(
        json['reactedAt'] ?? DateTime.now().toIso8601String(),
      ),
      viewAt: json['viewAt'] != null ? DateTime.parse(json['viewAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userStoryId': userStoryId,
      'petId': petId,
      'applicationUserId': applicationUserId,
      'reactType': reactType,
      'userName': userName,
      'userImage': userImage,
      'petname': petName,
      'petImage': petImage,
      'reactedAt': reactedAt.toIso8601String(),
      'viewAt': viewAt?.toIso8601String(),
    };
  }
}
