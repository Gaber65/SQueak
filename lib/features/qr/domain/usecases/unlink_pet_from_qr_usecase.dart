import 'package:dartz/dartz.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../repositories/qr_repository.dart';

class UnlinkPetFromQrUseCase extends BaseUseCase<bool, String> {
  final QrRepository repository;

  UnlinkPetFromQrUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String parameters) async {
    return await repository.unlinkPetFromQr(parameters);
  }


}
