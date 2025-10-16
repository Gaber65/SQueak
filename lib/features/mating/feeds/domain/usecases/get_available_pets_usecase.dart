import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../entities/pet_mating_entity.dart';
import '../repositories/pet_mating_repository.dart';

class GetAvailablePetsUseCase
    extends BaseUseCase<List<PetMatingEntity>, NoParameters> {
  final BasePetMatingRepository repository;

  GetAvailablePetsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetMatingEntity>>> call(
    NoParameters parameters,
  ) async {
    return await repository.getAvailablePets();
  }
}
