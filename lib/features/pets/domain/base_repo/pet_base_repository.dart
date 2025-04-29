import '../../../../core/utils/export_path/export_files.dart';
import '../entities/pet_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PetRepository {
  Future<Either<Failure, List<PetEntity>>> getOwnerPets();
  Future<Either<Failure, List<BreedEntity>>> getAllBreeds();
  Future<Either<Failure, List<BreedEntity>>> getBreedsBySpeciesId(String speciesId);
  Future<Either<Failure, List<SpeciesEntity>>> getAllSpecies();
  Future<Either<Failure, PetEntity>> createPet(PetEntity pet);
  Future<Either<Failure, PetEntity>> updatePet(PetEntity pet);
  Future<Either<Failure, void>> deletePet(String id);
}