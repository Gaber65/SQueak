import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/dio.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/usecases/create_story.dart';
import '../../domain/usecases/get_all_friend_stories_usecase.dart';
import '../../domain/usecases/get_my_active_stories_usecase.dart';
import '../../domain/usecases/send_reply_msg_to_story_pet.dart';
import 'story_state.dart';

import '../../domain/usecases/delete_story_usecase.dart';
import '../../domain/usecases/get_friends_stories_usecase.dart';
import '../../domain/usecases/get_story_reactions_usecase.dart';
import '../../domain/usecases/react_to_story_usecase.dart';

class StoryCubit extends Cubit<StoryState> {

  final CreateStoryUseCase createStoryUseCase;
  final DeleteStoryUseCase deleteStoryUseCase;
  final GetMyActiveStoriesUseCase getMyActiveStoriesUseCase;
  final GetFriendsStoriesUseCase getFriendsStoriesUseCase;
  final GetStoryReactionsUseCase getStoryReactionsUseCase;
  final ReactToStoryUseCase reactToStoryUseCase;
  final GetAllFriendStoriesUseCase getAllFriendStoriesUseCase;
  final SendReplyMsgToStoryPetUseCase sendReplyMsgToStoryPetUseCase;

  StoryCubit({
    required this.createStoryUseCase,
    required this.deleteStoryUseCase,
    required this.getMyActiveStoriesUseCase,
    required this.sendReplyMsgToStoryPetUseCase,
    required this.getFriendsStoriesUseCase,
    required this.getStoryReactionsUseCase,
    required this.reactToStoryUseCase,
    required this.getAllFriendStoriesUseCase,
  }) : super(const StoryState());

  static StoryCubit get(context) => BlocProvider.of(context);

  // Create Story
  Future<void> createStory({
    required String image,
    required String petId,
  }) async {
    emit(state.copyWith(status: StoryStatus.creating));

    final result = await createStoryUseCase(
      CreateStoryParams(image: image, petId: petId, dateTimeInUTC: DateTime.now().toUtc()),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StoryStatus.error,
          errorMessage: extractFirstErrorAuth(failure.error),
        ),
      ),
      (story) {
        emit(state.copyWith(status: StoryStatus.success));
        loadMyStories(petId); // Refresh
      },
    );
  }

  // Delete Story
  Future<void> deleteStory(String storyId, String petId) async {
    emit(state.copyWith(status: StoryStatus.deleting));

    final result = await deleteStoryUseCase(storyId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StoryStatus.error,
          errorMessage: extractFirstErrorAuth(failure.error),
        ),
      ),
      (_) {
        emit(state.copyWith(status: StoryStatus.success));
        loadMyStories(petId);
      },
    );
  }

  // Load My Stories
  Future<void> loadMyStories(String petId) async {
    emit(state.copyWith(status: StoryStatus.loading));

    final result = await getMyActiveStoriesUseCase(petId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StoryStatus.error,
          errorMessage: extractFirstErrorAuth(failure.error),
        ),
      ),
      (stories) =>
          emit(state.copyWith(status: StoryStatus.loaded, myStories: stories)),
    );
  }

  // Load Friends Stories
  Future<void> loadFriendsStories(String petId) async {
    emit(state.copyWith(status: StoryStatus.loading));

    final result = await getFriendsStoriesUseCase(petId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StoryStatus.error,
          errorMessage: extractFirstErrorAuth(failure.error),
        ),
      ),
      (stories) {
        emit(
          state.copyWith(status: StoryStatus.loaded, friendsStories: stories),
        );
      },
    );
  }

  // Get Story Reactions
  Future<void> loadStoryReactions({
    required String userStoryId,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final result = await getStoryReactionsUseCase(
      GetStoryReactionsParams(
        userStoryId: userStoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: StoryStatus.error,
          errorMessage: extractFirstErrorAuth(failure.error),
        ),
      ),
      (reactions) => emit(state.copyWith(reactions: reactions)),
    );
  }

  // React to Story
  Future<void> reactToStory({
    required String userStoryId,
    required int? reactType,
    required String petId,
  }) async {
    emit(state.copyWith(isReacting: true));

    final result = await reactToStoryUseCase(
      ReactToStoryParams(
        userStoryId: userStoryId,
        reactType: reactType ?? 0,
        petId: petId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isReacting: false,
          errorMessage: extractFirstErrorAuth(failure.error),
        ),
      ),
      (_) {
        markStoryAsViewed(userStoryId, reactType);
        emit(state.copyWith(isReacting: false));
      },
    );
  }

  void markStoryAsViewed(String userStoryId, reactType) {
    final updatedFriendsStories =
        state.friendsStories.map((friendStory) {
          final updatedUserStories =
              friendStory.userStories.map((story) {
                if (story.id == userStoryId) {
                  return story.copyWith(isViewed: true, myReactType: reactType);
                }
                return story;
              }).toList();

          return friendStory.copyWith(userStories: updatedUserStories);
        }).toList();

    emit(state.copyWith(friendsStories: updatedFriendsStories));
  }

  Future<List<StoryEntity>> loadAllFriendStories(String petId) async {
    emit(state.copyWith(status: StoryStatus.loading));

    final result = await getAllFriendStoriesUseCase(petId);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: StoryStatus.error,
            errorMessage: extractFirstErrorAuth(failure.error),
          ),
        );
        return <StoryEntity>[];
      },
      (stories) {
        emit(
          state.copyWith(status: StoryStatus.loaded, allFrindStoryes: stories),
        );
        return stories;
      },
    );
  }

  // Send Reply Msg To Story Pet
  Future<void> sendReplyMsgToStoryPet({
    required String userStoryId,
    required String message,
    required String replyTo,
    required String petId,
  }) async {
    emit(state.copyWith(isReacting: true));

    final result = await sendReplyMsgToStoryPetUseCase(
      SendReplyMsgToStoryPetParams(
        storyId: userStoryId,
        fromPetId: petId,
        toPetId: replyTo,
        description: message,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isReacting: false,
          errorMessage: extractFirstErrorAuth(failure.error),
        ),
      ),
      (_) {
        emit(
          state.copyWith(isReacting: false, status: StoryStatus.sendingReply),
        );
      },
    );
  }

  void clearError() => emit(state.copyWith(errorMessage: null));
}
