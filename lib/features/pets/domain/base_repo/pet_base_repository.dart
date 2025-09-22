import 'package:squeak/features/auth/get_started/domain/entites/request_pet_inteties.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../entities/pet_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PetRepository {
  Future<Either<Failure, List<PetEntities>>> getOwnerPets();
  Future<Either<Failure, List<BreedEntity>>> getAllBreeds();
  Future<Either<Failure, List<BreedEntity>>> getBreedsBySpeciesId(
    String speciesId,
  );
  Future<Either<Failure, List<SpeciesEntity>>> getAllSpecies();
  Future<Either<Failure, PetEntities>> createPet(PetEntities pet);
  Future<Either<Failure, PetEntities>> updatePet(PetEntities pet);
  Future<Either<Failure, void>> deletePet(String id);
}
