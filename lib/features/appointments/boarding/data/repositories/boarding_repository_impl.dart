import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/boarding_entry_entity.dart';
import '../../domain/entities/boarding_type_entity.dart';
import '../../domain/repositories/boarding_repository.dart';
import '../../domain/usecases/share_image_usecase.dart';
import '../datasources/boarding_local_data_source.dart';
import '../datasources/boarding_remote_data_source.dart';

class BoardingRepositoryImpl implements BoardingRepository {
  final BoardingRemoteDataSource remoteDataSource;
  final BoardingLocalDataSource localDataSource;

  BoardingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<BoardingTypeEntity>>> getBoardingTypes(
    String clinicCode,
  ) async {
    try {
      final result = await remoteDataSource.getBoardingTypes(clinicCode);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> createBoarding(
    CreateBoardingParams params,
  ) async {
    try {
      await remoteDataSource.createBoarding(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> editBoarding(EditBoardingParams params) async {
    try {
      await remoteDataSource.editBoarding(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<BoardingEntryEntity>>> getBoardingEntries(
    String phone,
    bool applyFilter,
  ) async {
    try {
      final cachedEntries = await localDataSource.getCachedBoardingEntries();
      if (cachedEntries.isNotEmpty) {
        final cachedResult =
            cachedEntries.map((model) => model.toEntity()).toList();

        if (applyFilter) {
          final filtered =
              cachedResult.where((entry) {
                return entry.existDate.isAfter(
                  DateTime.now().subtract(const Duration(days: 1)),
                );
              }).toList();

          return Right(filtered);
        }

        return Right(cachedResult);
      }
    } catch (_) {}

    try {
      final remoteEntries = await remoteDataSource.getBoardingEntries(
        phone,
        applyFilter,
      );

      await localDataSource.cacheBoardingEntries(remoteEntries);

      List<BoardingEntryEntity> result =
          remoteEntries.map((model) => model.toEntity()).toList();

      if (applyFilter) {
        result =
            result.where((entry) {
              return entry.existDate.isAfter(
                DateTime.now().subtract(const Duration(days: 1)),
              );
            }).toList();
      }

      return Right(result);
    } on ServerException catch (e) {
      try {
        final fallbackCached = await localDataSource.getCachedBoardingEntries();
        return Right(fallbackCached.map((model) => model.toEntity()).toList());
      } catch (_) {
        return Left(ServerFailure(e.errorMessageModel));
      }
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.errorMessage as dynamic));
    }
  }

  @override
  Future<Either<Failure, void>> rateBoarding(RateBoardingParams params) async {
    try {
      await remoteDataSource.rateBoarding(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, void>> shareImage(
    ShareImageBoardingEntriesParams params,
  ) async {
    try {
      await remoteDataSource.shareImage(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }
}
