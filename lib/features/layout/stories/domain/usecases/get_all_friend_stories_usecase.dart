import 'package:dartz/dartz.dart';
import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetAllFriendStoriesUseCase
    extends BaseUseCase<List<StoryEntity>, String> {
  final StoryRepository repository;

  GetAllFriendStoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<StoryEntity>>> call(String petId) async {
    return await repository.getAllFriendStories(petId);
  }
}
