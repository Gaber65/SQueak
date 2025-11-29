// lib/features/stories/data/models/story_model.dart
import '../../domain/entities/story.dart';

class StoryModel extends Story {
  StoryModel({
    required super.id,
    required super.ownerId,
    required super.ownerName,
    required super.ownerAvatarUrl,
    required super.imageUrl,
    required super.createdAt,
    required super.ttl,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      ownerAvatarUrl: json['ownerAvatarUrl'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      ttl: json['ttlSeconds'],
    );
  }
}

