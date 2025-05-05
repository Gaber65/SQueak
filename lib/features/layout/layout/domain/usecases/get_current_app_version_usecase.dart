import 'package:dartz/dartz.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../repositories/layout_repository.dart';

class GetCurrentAppVersionUseCase extends BaseUseCase<String, NoParameters> {
  final LayoutRepository repository;

  GetCurrentAppVersionUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParameters params) async {
    return await repository.getCurrentAppVersion();
  }
}
