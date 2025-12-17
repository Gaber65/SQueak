import 'package:dartz/dartz.dart';
import 'package:squeak/core/error/failure.dart';
import 'package:squeak/core/service/main_service/domain/entities/image_entity.dart';
import '../../../../base_usecase/base_usecase.dart';
import '../repositories/app_repository.dart';

class ManageUploadSoundUseCase
    extends BaseUseCase<ImageEntity, UploadImageParams> {
  final AppRepository repository;

  ManageUploadSoundUseCase(this.repository);

  @override
  Future<Either<Failure, ImageEntity>> call(
    UploadImageParams parameters,
  ) async {
    return await repository.uploadSound(
      parameters.file,
      parameters.uploadPlace,
    );
  }
}
