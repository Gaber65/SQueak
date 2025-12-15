import 'package:dartz/dartz.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/chat/domain/usecases/parameters.dart';

class RateMatingUseCase extends BaseUseCase<bool, RateMatingParameters> {
  final BaseChatRepository repository;

  RateMatingUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(RateMatingParameters params) async {
    return await repository.rateMating(params);
  }
}
