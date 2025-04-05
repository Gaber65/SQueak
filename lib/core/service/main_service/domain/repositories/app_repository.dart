import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:squeak/core/service/main_service/domain/entities/image_entity.dart';
import '../../../../error/failure.dart';
import '../../../../utils/enums/upload_place.dart';
import '../entities/language_entity.dart';

abstract class AppRepository {
  // Language methods
  Future<void> changeLanguage(LanguageEntity languageEntity);

  // Token management methods
  Future<void> deleteToken();
  Future<void> saveToken();
  Future<void> removeToken();
  Future<void> requestNotificationPermissions();

  // File upload methods
  Future<Either<Failure, ImageEntity>>uploadImage(File file ,UploadPlace uploadPlace);
  Future<Either<Failure, ImageEntity>> uploadVideo(File file ,UploadPlace uploadPlace);
  Future<Either<Failure, ImageEntity>> uploadSound(File file,UploadPlace uploadPlace);
}
class UploadImageParams {
  final File file;
  final UploadPlace uploadPlace;

  UploadImageParams({required this.file, required this.uploadPlace});
}
