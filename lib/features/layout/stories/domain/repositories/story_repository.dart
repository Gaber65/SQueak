import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/paginated_reactions_entity.dart';
import '../entities/story.dart';

abstract class StoryRepository {
  Future<Either<Failure, String>> createStory(CreateStoryParams params);
  Future<Either<Failure, bool>> deleteStory(String storyId);
  Future<Either<Failure, List<StoryEntity>>> getMyActiveStories(String petId);
  Future<Either<Failure, List<FrindStoryEntity>>> getFriendsStories(
    String petId,
  );
  Future<Either<Failure, PaginatedReactionsEntity>> getStoryReactions({
    required String userStoryId,
    required int pageNumber,
    required int pageSize,
  });
  Future<Either<Failure, bool>> reactToStory(ReactToStoryParams params);
  Future<Either<Failure, List<StoryEntity>>> getAllFriendStories(String petId);

  Future<Either<Failure, String>> sendReplyMsgToStoryPet(
    SendReplyMsgToStoryPetParams params,
  );
}

// Repository Parameters
class CreateStoryParams {
  final String image; // base64 or path
  final String petId;
  final DateTime dateTimeInUTC;

  CreateStoryParams({
    required this.image,
    required this.petId,
    required this.dateTimeInUTC,
  });

  Map<String, dynamic> toJson() => {
    'image': image,
    'petId': petId,
    'dateTimeInUTC': dateTimeInUTC.toIso8601String(),
  };
}

class ReactToStoryParams {
  final String userStoryId;
  final int reactType;
  final String petId;

  ReactToStoryParams({
    required this.userStoryId,
    required this.reactType,
    required this.petId,
  });

  Map<String, dynamic> toJson() => {
    'userStoryId': userStoryId,
    'reactType': reactType,
    'petId': petId,
  };
}

class SendReplyMsgToStoryPetParams {
  final String storyId;
  final String fromPetId;
  final String toPetId;
  final String description;

  SendReplyMsgToStoryPetParams({
    required this.storyId,
    required this.fromPetId,
    required this.toPetId,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'storyId': storyId,
    'fromPetId': fromPetId,
    'toPetId': toPetId,
    'description': description,
  };
}
