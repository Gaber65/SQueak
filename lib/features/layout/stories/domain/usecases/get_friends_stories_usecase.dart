import 'package:dartz/dartz.dart';
import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetFriendsStoriesUseCase extends BaseUseCase<List<FrindStoryEntity>, String> {
  final StoryRepository repository;

  GetFriendsStoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<FrindStoryEntity>>> call(String petId) async {
    return await repository.getFriendsStories(petId);
  }
}
