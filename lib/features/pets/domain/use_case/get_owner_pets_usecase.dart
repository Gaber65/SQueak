import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/pet_base_repository.dart';
import '../entities/pet_entity.dart';

class GetOwnerPetsUseCase extends BaseUseCase<List<PetEntities>, NoParameters> {
  final PetRepository repository;

  GetOwnerPetsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetEntities>>> call(NoParameters parameters) {
    return repository.getOwnerPets();
  }
}
