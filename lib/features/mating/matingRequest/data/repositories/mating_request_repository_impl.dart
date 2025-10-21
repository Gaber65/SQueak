import 'package:dartz/dartz.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/mating_request_entity.dart';

class MatingRequestRepositoryImpl implements MatingRequestRepository {
  final MatingRequestRemoteDataSource remoteDataSource;

  MatingRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MatingRequestEntity>>> getMatingRequests(
    String petId,
  ) async {
    try {
      final result = await remoteDataSource.getMatingRequests(petId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<MatingRequestEntity>>> getMatingSent(
      String petId,
      ) async {
    try {
      final result = await remoteDataSource.getMatingSent(petId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, String>> updateRequestStatus(UpdateRequestStatusParams params) async {
    try {
      final result = await remoteDataSource.updateRequestStatus(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
