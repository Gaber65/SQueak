import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/mating_request_entity.dart';
import '../repositories/pet_mating_repository.dart';
import 'mating_parameters.dart';

class SendMatingRequestUseCase extends BaseUseCase<MatingRequestEntity, SendMatingRequestParameters> {
  final BasePetMatingRepository repository;

  SendMatingRequestUseCase(this.repository);

  @override
  Future<Either<Failure, MatingRequestEntity>> call(SendMatingRequestParameters parameters) async {
    return await repository.sendMatingRequest(parameters);
  }
}