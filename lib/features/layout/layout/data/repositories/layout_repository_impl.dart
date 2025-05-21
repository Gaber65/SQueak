import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../domain/entities/version_entity.dart';
import '../../domain/repositories/layout_repository.dart';
import '../datasources/layout_local_data_source.dart';
import '../datasources/layout_remote_data_source.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class LayoutRepositoryImpl implements LayoutRepository {
  final LayoutRemoteDataSource remoteDataSource;
  final LayoutLocalDataSource localDataSource;

  LayoutRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, VersionEntity>> getVersion() async {
    try {
      final remoteVersion = await remoteDataSource.getVersion();
      return Right(remoteVersion.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentAppVersion() async {
    try {
      final currentVersion = await localDataSource.getCurrentAppVersion();
      return Right(currentVersion);
    } on LocalDatabaseException catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.errorMessage,
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }
}
