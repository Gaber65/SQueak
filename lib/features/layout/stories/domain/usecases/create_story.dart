import 'package:dartz/dartz.dart';

import 'package:squeak/core/error/failure.dart';

import '../../../../../core/base_usecase/base_usecase.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

class CreateStoryUseCase extends BaseUseCase<String, CreateStoryParams> {
  final StoryRepository repository;

  CreateStoryUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateStoryParams params) async {
    return await repository.createStory(params);
  }
}
