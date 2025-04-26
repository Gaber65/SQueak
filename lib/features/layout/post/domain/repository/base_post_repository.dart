import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../entities/post_entity.dart';

abstract class BasePostRepository {
  Future<Either<Failure, List<PostEntity>>> getAllUserPosts(int allPostUserPageNumber);
}
