import 'package:dartz/dartz.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../entities/version_entity.dart';
import '../repositories/layout_repository.dart';

class GetVersionUseCase extends BaseUseCase<VersionEntity, NoParameters> {
  final LayoutRepository repository;

  GetVersionUseCase(this.repository);

  @override
  Future<Either<Failure, VersionEntity>> call(NoParameters params) async {
    return await repository.getVersion();
  }
}
