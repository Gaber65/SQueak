import 'package:dartz/dartz.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class GetAvailablePetsUseCase extends BaseUseCase<List<PetEntities>, String> {
  final BasePetMatingRepository repository;

  GetAvailablePetsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetEntities>>> call(String specieId) async {
    return await repository.getAvailablePets(specieId);
  }
}
