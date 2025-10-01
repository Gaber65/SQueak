import 'package:dartz/dartz.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../../domain/base_repo/pet_base_repository.dart';
import '../../domain/entities/pet_entity.dart';
import '../data_source/pet_local_data_source.dart';
import '../data_source/pet_remote_data_source.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;
  final PetLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PetRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PetEntities>>> getOwnerPets() async {
    return await _fetchPetsFromRemote();
  }

  /// Fetch from remote and cache
  Future<Either<Failure, List<PetEntities>>> _fetchPetsFromRemote() async {
    try {
      final remotePets = await remoteDataSource.getOwnerPets();
      await localDataSource.cachePets(remotePets);
      return Right(remotePets);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<BreedEntity>>> getAllBreeds() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBreeds = await remoteDataSource.getAllBreeds();
        await localDataSource.cacheBreeds(remoteBreeds);
        return Right(remoteBreeds.map((breed) => breed).toList());
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      try {
        final localBreeds = await localDataSource.getCachedBreeds();
        return Right(localBreeds.map((breed) => breed).toList());
      } on LocalDatabaseFailure catch (failure) {
        return Left(LocalDatabaseFailure(failure.error));
      }
    }
  }

  @override
  Future<Either<Failure, List<BreedEntity>>> getBreedsBySpeciesId(
    String speciesId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBreeds = await remoteDataSource.getBreedsBySpeciesId(
          speciesId,
        );
        return Right(remoteBreeds.map((breed) => breed).toList());
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return const Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<SpeciesEntity>>> getAllSpecies() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSpecies = await remoteDataSource.getAllSpecies();
        return Right(
          remoteSpecies
              .map(
                (species) =>
                    SpeciesEntity(id: species.id, type: species.enType),
              )
              .toList(),
        );
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return const Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PetEntities>> createPet(PetEntities pet) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePet = await remoteDataSource.createPet(pet);
        final pets = await localDataSource.getCachedPets();
        pets.add(remotePet);
        await localDataSource.cachePets(pets);

        return Right(remotePet);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return const Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PetEntities>> updatePet(PetEntities pet) async {
    if (await networkInfo.isConnected) {
      try {
        final petData = PetData(
          petId: pet.petId,
          petName: pet.petName,
          breedId: pet.breedId,
          isSpayed: pet.isSpayed,
          gender: pet.gender,
          specieId: pet.specieId,
          imageName: pet.imageName,
          birthdate: pet.birthdate,
          passportNumber: pet.passportNumber,
          passportImage: pet.passportImage,
          microShipNumber: pet.microShipNumber,
        );

        final remotePet = await remoteDataSource.updatePet(
          pet.petId.toString(),
          petData,
        );
        final pets = await localDataSource.getCachedPets();
        final index = pets.indexWhere((p) => p.petId == pet.petId);
        if (index != -1) {
          pets[index] = remotePet;
          await localDataSource.cachePets(pets);
        }

        return Right(remotePet);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return const Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deletePet(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deletePet(id);
        final pets = await localDataSource.getCachedPets();
        pets.removeWhere((p) => p.petId.toString() == id);
        await localDataSource.cachePets(pets);

        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return const Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PetEntities>> mergePets(List<String> ids) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePets = await remoteDataSource.mergePets(ids);
        await localDataSource.cachePets(remotePets);
        return Right(remotePets.first);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return const Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  
}
