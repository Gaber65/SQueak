import 'package:dartz/dartz.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/boarding_entry_entity.dart';
import '../../domain/entities/boarding_type_entity.dart';

class BoardingRepositoryImpl implements BoardingRepository {
  final BoardingRemoteDataSource remoteDataSource;

  BoardingRepositoryImpl({
    required this.remoteDataSource,
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
      final remoteEntries = await remoteDataSource.getBoardingEntries(
        phone,
        applyFilter,
      );
      final result = remoteEntries.map((e) => e.toEntity()).toList();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
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