class StoryReactionEntity {
  final String id;
  final String userStoryId;
  final String? petId;
  final String? applicationUserId;
  final int reactType;
  final String? userName;
  final String? userImage;
  final String? petName;
  final String? petImage;
  final DateTime reactedAt;
  final DateTime? viewAt;

  const StoryReactionEntity({
    required this.id,
    required this.userStoryId,
    this.petId,
    this.applicationUserId,
    required this.reactType,
    this.userName,
    this.userImage,
    this.petName,
    this.petImage,
    required this.reactedAt,
    this.viewAt,
  });

}

