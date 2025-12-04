import '../../domain/entities/story.dart';

class StoryModel extends StoryEntity {
  StoryModel({
    required super.id,
    required super.petId,
    super.image,
    super.video,
    required super.isViewed,
    required super.myReactType,
    required super.description,
    required super.issueDate,
    required super.expireDate,
    required super.petName,
    required super.petImage,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      petId: json['petId'] ?? '',
      image: json['image'],
      video: json['video'],
      isViewed: json['isViewed'] ?? false,
      myReactType: json['myReactType'],
      description: json['description'] ?? '',
      issueDate: DateTime.tryParse(json['issueDate'] ?? '') ?? DateTime(0001),
      expireDate: DateTime.tryParse(json['expireDate'] ?? '') ?? DateTime(0001),
      petName: json['petName'] ?? '',
      petImage: json['petImage'] ?? '',
    );
  }
  factory StoryModel.fromEntity(StoryEntity entity) {
    return StoryModel(
      id: entity.id,
      petId: entity.petId,
      image: entity.image,
      video: entity.video,
      isViewed: entity.isViewed,
      myReactType: entity.myReactType,
      description: entity.description,
      issueDate: entity.issueDate,
      expireDate: entity.expireDate,
      petName: entity.petName,
      petImage: entity.petImage,
    );
  }
}

class FrindStoryModel extends FrindStoryEntity {
  FrindStoryModel({
    required super.petId,
    required super.petName,
    required super.petImage,
    required super.userStories,
  });

  factory FrindStoryModel.fromJson(Map<String, dynamic> json) {
    final List<StoryModel> stories =
        (json['userStories'] as List<dynamic>)
            .map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
            .toList();

    stories.sort((a, b) => a.isViewed ? 1 : -1);

    return FrindStoryModel(
      petId: json['id'] ?? '',
      petName: json['petName'] ?? '',
      petImage: json['imageName'] ?? '',
      userStories: stories,
    );
  }
}
