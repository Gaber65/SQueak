class StoryEntity {
  final String id;
  final String petId;
  final String? image;
  final String? video;
  final String description;
  final DateTime issueDate;
  final DateTime expireDate;
  final DateTime createdAt;
  final String petName;
  final String petImage;
  final bool isViewed;
  final int? myReactType;

  const StoryEntity({
    required this.id,
    required this.petId,
    this.image,
    this.video,
    required this.isViewed,
    required this.createdAt,
    required this.myReactType,
    required this.description,
    required this.issueDate,
    required this.expireDate,
    required this.petName,
    required this.petImage,
  });

  StoryEntity copyWith({bool? isViewed, int? myReactType}) {
    return StoryEntity(
      id: id,
      createdAt: createdAt,
      petId: petId,
      image: image,
      video: video,
      description: description,
      issueDate: issueDate,
      expireDate: expireDate,
      petName: petName,
      petImage: petImage,
      isViewed: isViewed ?? this.isViewed,
      myReactType: myReactType ?? this.myReactType,
    );
  }
}

class FrindStoryEntity {
  final String petId;
  final String petName;
  final String petImage;
  final List<StoryEntity> userStories;

  FrindStoryEntity({
    required this.petId,
    required this.petName,
    required this.petImage,
    required this.userStories,
  });

  FrindStoryEntity copyWith({List<StoryEntity>? userStories}) {
    return FrindStoryEntity(
      petId: petId,
      petName: petName,
      petImage: petImage,
      userStories: userStories ?? this.userStories,
    );
  }
}
