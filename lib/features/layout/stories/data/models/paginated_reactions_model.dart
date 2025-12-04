import '../../domain/entities/paginated_reactions_entity.dart';
import 'story_reaction_model.dart';

class PaginatedReactionsModel extends PaginatedReactionsEntity {
  const PaginatedReactionsModel({
    required super.reactions,
    required super.pageNumber,
    required super.pageSize,
    required super.totalPages,
    required super.totalCount,
    required super.hasPrevious,
    required super.hasNext,
  });

  factory PaginatedReactionsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedReactionsModel(
      reactions: (json['result'] as List?)
          ?.map((e) => StoryReactionModel.fromJson(e))
          .toList() ?? [],
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      hasPrevious: json['hasPrevious'] ?? false,
      hasNext: json['hasNext'] ?? false,
    );
  }
}
