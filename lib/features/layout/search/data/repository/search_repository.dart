import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/exception.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/features/layout/search/domain/entities/clinic_search_entity.dart';
import 'package:squeak/features/layout/search/domain/entities/vet_client_search_entity.dart';
import 'package:squeak/features/layout/search/domain/repository/base_search_repository.dart';

import '../data_source/search_data_source.dart';

class SearchRepository extends BaseSearchRepository {
  final BaseSearchRemoteDataSource baseSearchRemoteDataSource;

  SearchRepository(this.baseSearchRemoteDataSource);

  @override
  Future<Either<Failure, List<ClinicEntitySearch>>> getSearchList(
    String clinicCode,
  ) async {
    try {
      final result = await baseSearchRemoteDataSource.getSearchList(clinicCode);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<VetSearchClientEntity>>> getClintFormVetVoid(
    String clinicCode,
  ) async {
    try {
      final result = await baseSearchRemoteDataSource.getClientFormVet(
        clinicCode,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, ClinicEntitySearch>> followClinic(
    String clinicId,
  ) async {
    try {
      final result = await baseSearchRemoteDataSource.followClinic(clinicId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, ClinicEntitySearch>> unfollowClinic(
    String clinicId,
  ) async {
    try {
      final result = await baseSearchRemoteDataSource.unfollowClinic(clinicId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, SupplierEntitySearch>> getSupplier() async {
    try {
      final result = await baseSearchRemoteDataSource.getSupplier();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
