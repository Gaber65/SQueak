import '../../domain/entities/story.dart';
import '../../domain/entities/paginated_reactions_entity.dart';

enum StoryStatus {
  initial,
  loading,
  loaded,
  creating,
  deleting,
  sendingReply,
  success,
  error,
}

class StoryState {
  final StoryStatus status;
  final List<StoryEntity> myStories;
  final List<FrindStoryEntity> friendsStories;
  final List<StoryEntity> allFrindStoryes;
  final PaginatedReactionsEntity? reactions;
  final String? errorMessage;
  final bool isReacting;

  const StoryState({
    this.status = StoryStatus.initial,
    this.myStories = const [],
    this.allFrindStoryes = const [],
    this.friendsStories = const [],
    this.reactions,
    this.errorMessage,
    this.isReacting = false,
  });

  StoryState copyWith({
    StoryStatus? status,
    List<StoryEntity>? myStories,
    List<StoryEntity>? allFrindStoryes,
    List<FrindStoryEntity>? friendsStories,
    PaginatedReactionsEntity? reactions,
    String? errorMessage,
    bool? isReacting,
  }) {
    return StoryState(
      status: status ?? this.status,
      myStories: myStories ?? this.myStories,
      allFrindStoryes: allFrindStoryes ?? this.allFrindStoryes,
      friendsStories: friendsStories ?? this.friendsStories,
      reactions: reactions ?? this.reactions,
      errorMessage: errorMessage,
      isReacting: isReacting ?? this.isReacting,
    );
  }
}
