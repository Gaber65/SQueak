import 'story_reaction_entity.dart' show StoryReactionEntity;

class PaginatedReactionsEntity {
  final List<StoryReactionEntity> reactions;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasPrevious;
  final bool hasNext;

  const PaginatedReactionsEntity({
    required this.reactions,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasPrevious,
    required this.hasNext,
  });
}
