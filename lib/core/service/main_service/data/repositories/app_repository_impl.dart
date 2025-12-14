import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:squeak/core/network/end_points.dart';
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
    final subtype = remoteDataSource.getImageSubtype(file.path);
    final result = await remoteDataSource.uploadFile(
      file,
      imageHelperEndPoint,
      uploadPlace.value,
      "image",
      subtype,

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
    // Detect audio subtype from file extension
    String extension = file.path.split('.').last.toLowerCase();
    String subtype;
    
    switch (extension) {
      case 'mp3':
        subtype = 'mpeg';
        break;
      case 'aac':
        subtype = 'aac';
        break;
      case 'ogg':
        subtype = 'ogg';
        break;
      case 'opus':
        subtype = 'opus';
        break;
      case 'wav':
        subtype = 'wav';
        break;
      case 'm4a':
        subtype = 'x-m4a';
        break;
      case 'midi':
        subtype = 'midi';
        break;
      case 'amr':
        subtype = 'amr';
        break;
      case 'wma':
        subtype = 'x-ms-wma';
        break;
      case 'webm':
        subtype = 'webm';
        break;
      default:
        subtype = 'mpeg'; // fallback to mp3
    }
    
    final result = await remoteDataSource.uploadFile(
      file,
      audioHelperEndPoint,
      uploadPlace.value,
      "audio",
      subtype,
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
  Future<Either<Failure, ImageEntity>> uploadDocument(
    File file,
    UploadPlace uploadPlace,
  ) async {
    String extension = file.path.split('.').last.toLowerCase();
    String subtype;
    String type = 'application';
    
    switch (extension) {
      case 'pdf':
        subtype = 'pdf';
        break;
      case 'doc':
        subtype = 'msword';
        break;
      case 'docx':
        subtype = 'vnd.openxmlformats-officedocument.wordprocessingml.document';
        break;
      case 'xls':
        subtype = 'vnd.ms-excel';
        break;
      case 'xlsx':
        subtype = 'vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        break;
      case 'ppt':
        subtype = 'vnd.ms-powerpoint';
        break;
      case 'pptx':
        subtype = 'vnd.openxmlformats-officedocument.presentationml.presentation';
        break;
      case 'txt':
        type = 'text';
        subtype = 'plain';
        break;
      case 'zip':
        subtype = 'zip';
        break;
      case 'rar':
        subtype = 'x-rar-compressed';
        break;
      case '7z':
        subtype = 'x-7z-compressed';
        break;
      default:
        subtype = 'octet-stream'; 
    }
    
    final result = await remoteDataSource.uploadFile(
      file,
      documentHelperEndPoint, 
      uploadPlace.value,
      type,
      subtype,
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
