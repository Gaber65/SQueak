import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:squeak/core/network/end-points.dart';
import 'package:squeak/core/utils/enums/upload_place.dart';

import '../../../../error/exception.dart';
import '../../../../error/failure.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/entities/language_entity.dart';
import '../../domain/repositories/app_repository.dart';
import '../datasources/remote_data_source.dart';

class AppRepositoryImpl implements AppRepository {
  final MainRemoteDataSource remoteDataSource;

  AppRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> changeLanguage(LanguageEntity languageEntity) async {
    await remoteDataSource.setLanguage(languageEntity.language);
  }

  @override
  Future<void> deleteToken() async {
    await remoteDataSource.deleteToken();
  }

  @override
  Future<void> saveToken() async {
    await remoteDataSource.saveToken();
  }

  @override
  Future<void> removeToken() async {
    await remoteDataSource.removeToken();
  }

  @override
  Future<void> requestNotificationPermissions() async {
    await remoteDataSource.requestNotificationPermissions();
  }

  @override
  Future<Either<Failure, ImageEntity>> uploadImage(
    File file,
    UploadPlace uploadPlace,
  ) async {
    final result = await remoteDataSource.uploadFile(
      file,
      imageHelperEndPoint,
      uploadPlace.value,
      "image",
      "jpeg",
    );

    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(
          failure.errorMessageModel.errors.isNotEmpty
              ? failure.errorMessageModel.errors.values.first.first
              : failure.errorMessageModel.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ImageEntity>> uploadVideo(
    File file,
    UploadPlace uploadPlace,
  ) async {
    final result = await remoteDataSource.uploadFile(
      file,
      videoHelperEndPoint,
      uploadPlace.value,
      "video",
      "mp4",
    );
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(
          failure.errorMessageModel.errors.isNotEmpty
              ? failure.errorMessageModel.errors.values.first.first
              : failure.errorMessageModel.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ImageEntity>> uploadSound(
    File file,
    UploadPlace uploadPlace,
  ) async {
    final result = await remoteDataSource.uploadFile(
      file,
      audioHelperEndPoint,
      uploadPlace.value,
      "audio",
      "Acc",
    );
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(
          failure.errorMessageModel.errors.isNotEmpty
              ? failure.errorMessageModel.errors.values.first.first
              : failure.errorMessageModel.message,
        ),
      );
    }
  }
}
