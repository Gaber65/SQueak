import 'package:dartz/dartz.dart';
import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/story_repository.dart';

class SendReplyMsgToStoryPetUseCase
    implements BaseUseCase<String, SendReplyMsgToStoryPetParams> {
  final StoryRepository storyRepository;

  SendReplyMsgToStoryPetUseCase(this.storyRepository);

  @override
  Future<Either<Failure, String>> call(SendReplyMsgToStoryPetParams params) {
    return storyRepository.sendReplyMsgToStoryPet(params);
  }
}
