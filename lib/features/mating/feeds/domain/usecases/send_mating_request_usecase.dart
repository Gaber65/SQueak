import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import 'mating_parameters.dart';

class SendMatingRequestUseCase
    extends BaseUseCase<String, SendMatingRequestParameters> {
  final BasePetMatingRepository repository;

  SendMatingRequestUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    SendMatingRequestParameters parameters,
  ) async {
    return await repository.sendMatingRequest(parameters);
  }
}
