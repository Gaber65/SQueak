import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/pet_base_repository.dart';
import '../entities/pet_entity.dart';

class GetBreedsBySpeciesUseCase extends BaseUseCase<List<BreedEntity>, String> {
  final PetRepository repository;

  GetBreedsBySpeciesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BreedEntity>>> call(String speciesId) {
    return repository.getBreedsBySpeciesId(speciesId);
  }
}
