import 'package:dartz/dartz.dart';
import 'package:squeak/features/vetcare/domain/entities/vet_client.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/base_repo/qr_base_repo.dart';
import '../data_sorce/qr_register_data_source.dart';

class QRRepositoryImpl implements QRRepository {
  final QRRemoteDataSource remoteDataSource;

  QRRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> checkClinicInSupplier(
    CheckClinicParams params,
  ) async {
    try {
      final result = await remoteDataSource.checkClinicInSupplier(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> followClinic(FollowClinicParams params) async {
    try {
      await remoteDataSource.followClinic(params);
      return Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<VetClient>>> getVetClients(
    GetVetClientsParams params,
  ) async {
    try {
      final result = await remoteDataSource.getVetClients(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }
}
