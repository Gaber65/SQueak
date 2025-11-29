// TODO: Implement story_repository.dart
// lib/features/stories/domain/repositories/story_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/story.dart';

abstract class StoryRepository {
  Future<Either<Failure, List<Story>>> getActiveStories();
  Future<Either<Failure, Story>> createStory(CreateStoryParams params);
}

class CreateStoryParams {
  final String ownerId;
  final String ownerName;
  final String ownerAvatarUrl;
  final String imageUrl;
  final DateTime? createdAt;

  CreateStoryParams({
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.imageUrl,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerAvatarUrl': ownerAvatarUrl,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
