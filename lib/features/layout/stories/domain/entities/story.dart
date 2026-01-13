class StoryEntity {
  final String id;
  final String petId;
  final String? image;
  final String? video;
  final String description;
  final String expireDate;
  final String createdAt;
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
    required this.expireDate,
    required this.petName,
    required this.petImage,
  });

  StoryEntity copyWith({
    String? id,
    String? createdAt,
    String? petId,
    String? image,
    String? video,
    String? description,
    String? expireDate,
    String? petName,
    String? petImage,
    bool? isViewed,
    int? myReactType,
  }) {
    return StoryEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      petId: petId ?? this.petId,
      image: image ?? this.image,
      video: video ?? this.video,
      description: description ?? this.description,
      expireDate: expireDate ?? this.expireDate,
      petName: petName ?? this.petName,
      petImage: petImage ?? this.petImage,
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
