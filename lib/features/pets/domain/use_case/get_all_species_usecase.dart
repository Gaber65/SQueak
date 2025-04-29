import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/pet_base_repository.dart';
import '../entities/pet_entity.dart';

class GetAllSpeciesUseCase
    extends BaseUseCase<List<SpeciesEntity>, NoParameters> {
  final PetRepository repository;

  GetAllSpeciesUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpeciesEntity>>> call(NoParameters parameters) {
    return repository.getAllSpecies();
  }
}
