import 'package:dartz/dartz.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';

class ReactOnPostUseCase
    extends BaseUseCase<ReactionActionResult, ReactParams> {
  final BaseReactRepo repository;

  ReactOnPostUseCase(this.repository);

  @override
  Future<Either<Failure, ReactionActionResult>> call(ReactParams params) async {
    return await repository.reactOnPost(params);
  }
}
