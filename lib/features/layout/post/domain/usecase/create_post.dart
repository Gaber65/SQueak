
import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../entities/post_entity.dart';
import '../repository/base_post_repository.dart';

class CreatePostUseCase extends BaseUseCase<PostEntity, CreatePostParams> {
  final BasePostRepository basePostRepository;

  CreatePostUseCase(this.basePostRepository);

  @override
  Future<Either<Failure, PostEntity>> call(CreatePostParams params) async {
    return await basePostRepository.createPost(params);
  }
}
