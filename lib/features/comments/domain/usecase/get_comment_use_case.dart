import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../core/base_usecase/base_usecase.dart';
import '../entities/comment_entity.dart';
import '../repository/base_comment_repository.dart';

class GetCommentPostUseCase
    extends BaseUseCase<List<CommentEntity>, CreateCommentParameters> {
  final BaseCommentRepository baseCommentRepository;

  GetCommentPostUseCase(this.baseCommentRepository);

  @override
  Future<Either<Failure, List<CommentEntity>>> call(
    CreateCommentParameters parameters,
  ) async {
    return await baseCommentRepository.getComment(parameters);
  }
}
