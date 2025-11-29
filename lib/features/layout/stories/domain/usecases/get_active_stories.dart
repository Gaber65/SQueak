// TODO: Implement get_active_stories.dart

// lib/features/stories/domain/usecases/get_active_stories.dart
import 'package:dartz/dartz.dart';

import 'package:squeak/core/error/failure.dart';

import '../../../../../core/base_usecase/base_usecase.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetActiveStoriesUseCase extends BaseUseCase<List<Story>, NoParameters> {
  final StoryRepository repo;
  GetActiveStoriesUseCase(this.repo);

  @override
  Future<Either<Failure, List<Story>>> call(NoParameters parameters) async {
    return await repo.getActiveStories();
  }
}
