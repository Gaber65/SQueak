import 'package:dartz/dartz.dart';
import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/story_repository.dart';

class DeleteStoryUseCase extends BaseUseCase<bool, String> {
  final StoryRepository repository;

  DeleteStoryUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String storyId) async {
    return await repository.deleteStory(storyId);
  }
}