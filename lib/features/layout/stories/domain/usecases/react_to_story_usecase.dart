import 'package:dartz/dartz.dart';
import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/story_repository.dart';

class ReactToStoryUseCase extends BaseUseCase<bool, ReactToStoryParams> {
  final StoryRepository repository;

  ReactToStoryUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReactToStoryParams params) async {
    return await repository.reactToStory(params);
  }
}
