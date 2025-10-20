import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/mating/profile/data/datasource/mating_profile_data_source.dart';
import 'package:squeak/features/mating/profile/domain/repo/base_mating_pet_profile_repo.dart';
import 'package:squeak/features/mating/profile/domain/usecases/mating_profile_prams.dart';

import '../../../../pets/domain/entities/pet_entity.dart';
import '../../domain/entities/history_entities.dart';

class MatingPetProfileRepoImpl implements BaseMatingPetProfileRepo {
  final MatingProfileDataSource matingProfileDataSource;

  MatingPetProfileRepoImpl(this.matingProfileDataSource);

  @override
  Future<Either<Failure, void>> updatePetStatus(
    MatingProfileParams params,
  ) async {
    try {
      final result = await matingProfileDataSource.updatePetStatus(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, PetEntities>> getPetProfile(String petId) async {
    try {
      final result = await matingProfileDataSource.getPetDate(petId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<HistoryEntity>>> getPetHistory(String petId) async {
    try {
      final result = await matingProfileDataSource.getPetDateHistory(petId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
