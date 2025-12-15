import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/pet_base_repository.dart';
import '../entities/pet_entity.dart';

import 'create_pet_usecase.dart'; // Reusing PetParams

class UpdatePetUseCase extends BaseUseCase<PetEntities, PetParams> {
  final PetRepository repository;

  UpdatePetUseCase(this.repository);

  @override
  Future<Either<Failure, PetEntities>> call(PetParams parameters) {
    return repository.updatePet(parameters.pet);
  }
}
