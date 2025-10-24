import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import 'mating_parameters.dart';

class UpdateSentRequestStatusUseCase
    extends BaseUseCase<void, SendMatingRequestParameters> {
  final BasePetMatingRepository repository;

  UpdateSentRequestStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
      SendMatingRequestParameters parameters,
  ) async {
    return await repository.updateSentRequestStatus(parameters);
  }
}
