import 'package:dartz/dartz.dart';

import 'package:squeak/core/error/failure.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_remote_datasource.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDataSource remoteDataSource;

  QrRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> linkPetToQr(
    String petId,
    String qrCodeId,
  ) async {
    try {
      return Right(await remoteDataSource.linkPetToQr(petId, qrCodeId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, bool>> unlinkPetFromQr(String petId) async {
    try {
      return Right(await remoteDataSource.unlinkPetFromQr(petId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  // @override
  // Future<bool> linkPetToQr(String petId, String qrCodeId) async {
  //   return await remoteDataSource.linkPetToQr(petId, qrCodeId);
  // }
  //
  // @override
  // Future<bool> unlinkPetFromQr(String petId) async {
  //   return await remoteDataSource.unlinkPetFromQr(petId);
  // }
}
