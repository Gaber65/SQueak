import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../entities/post_entity.dart';
import '../repository/base_post_repository.dart';

class GetAllPostUseCase extends BaseUseCase<List<PostEntity>, GetPostParams> {
  final BasePostRepository basePostRepository;

  GetAllPostUseCase(this.basePostRepository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(GetPostParams params) async {
    return await basePostRepository.getAllUserPosts(params);
  }
}
