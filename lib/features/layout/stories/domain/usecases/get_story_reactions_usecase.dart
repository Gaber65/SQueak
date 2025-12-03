import 'package:dartz/dartz.dart';
import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/paginated_reactions_entity.dart';
import '../repositories/story_repository.dart';

class GetStoryReactionsParams {
  final String userStoryId;
  final int pageNumber;
  final int pageSize;

  GetStoryReactionsParams({
    required this.userStoryId,
    required this.pageNumber,
    required this.pageSize,
  });
}

class GetStoryReactionsUseCase
    extends BaseUseCase<PaginatedReactionsEntity, GetStoryReactionsParams> {
  final StoryRepository repository;

  GetStoryReactionsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedReactionsEntity>> call(
      GetStoryReactionsParams params,
      ) async {
    return await repository.getStoryReactions(
      userStoryId: params.userStoryId,
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
    );
  }
}