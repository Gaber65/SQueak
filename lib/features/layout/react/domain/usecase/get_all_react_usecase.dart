import 'package:dartz/dartz.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/react_entities.dart';
import '../repo/base_react_repo.dart';

class GetAllReactOnPostUseCase extends BaseUseCase<ReactionSummary, String> {
  final BaseReactRepo repository;

  GetAllReactOnPostUseCase(this.repository);

  @override
  Future<Either<Failure, ReactionSummary>> call(String postId) async {
    return await repository.getAllReactOnPost(postId);
  }
}
