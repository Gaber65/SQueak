import 'package:dartz/dartz.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import '../../../../error/failure.dart';
import '../entities/image_entity.dart';
import '../repositories/app_repository.dart';

class ManageUploadDocumentUseCase
    extends BaseUseCase<ImageEntity, UploadImageParams> {
  final AppRepository repository;

  ManageUploadDocumentUseCase(this.repository);

  @override
  Future<Either<Failure, ImageEntity>> call(
    UploadImageParams parameters,
  ) async {
    return await repository.uploadDocument(
      parameters.file,
      parameters.uploadPlace,
    );
  }
}
