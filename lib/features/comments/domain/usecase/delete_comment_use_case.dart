import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../core/base_usecase/base_usecase.dart';
import '../entities/comment_entity.dart';
import '../repository/base_comment_repository.dart';

class DeleteCommentPostUseCase
    extends BaseUseCase<CommentEntity, CreateCommentParameters> {
  final BaseCommentRepository baseCommentRepository;

  DeleteCommentPostUseCase(this.baseCommentRepository);

  @override
  Future<Either<Failure, CommentEntity>> call(
    CreateCommentParameters parameters,
  ) async {
    return await baseCommentRepository.deleteComment(parameters);
  }
}
