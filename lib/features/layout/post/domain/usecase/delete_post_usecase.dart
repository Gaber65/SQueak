

import 'package:dartz/dartz.dart';

import '../../../../../core/base_usecase/base_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../repository/base_post_repository.dart';

class DeletePostUseCase extends BaseUseCase<bool, String> {
  final BasePostRepository repository;

  DeletePostUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String id) async {
    return await repository.deletePost(id);
  }
}