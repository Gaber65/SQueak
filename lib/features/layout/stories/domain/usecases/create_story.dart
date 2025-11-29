// TODO: Implement create_story.dart
// lib/features/stories/domain/usecases/create_story.dart
import 'package:dartz/dartz.dart';

import 'package:squeak/core/error/failure.dart';

import '../../../../../core/base_usecase/base_usecase.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

class CreateStoryUseCase extends BaseUseCase<Story, CreateStoryParams> {
  final StoryRepository repo;
  CreateStoryUseCase(this.repo);

  @override
  Future<Either<Failure, Story>> call(CreateStoryParams parameters) async {
    return await repo.createStory(parameters);
  }
}
