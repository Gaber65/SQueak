import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../repositories/pet_mating_repository.dart';
import 'mating_parameters.dart';

class UpdatePetStatusUseCase
    extends BaseUseCase<void, UpdatePetStatusParameters> {
  final BasePetMatingRepository repository;

  UpdatePetStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    UpdatePetStatusParameters parameters,
  ) async {
    return await repository.updatePetStatus(parameters);
  }
}
