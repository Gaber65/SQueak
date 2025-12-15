import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/pet_base_repository.dart';
import '../entities/pet_entity.dart';

class GetAllBreedsUseCase extends BaseUseCase<List<BreedEntity>, NoParameters> {
  final PetRepository repository;

  GetAllBreedsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BreedEntity>>> call(NoParameters parameters) {
    return repository.getAllBreeds();
  }
}
