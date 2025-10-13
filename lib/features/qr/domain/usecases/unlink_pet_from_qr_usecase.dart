import 'package:dartz/dartz.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';

class UnlinkPetFromQrUseCase extends BaseUseCase<bool, LinkPetToQrParams> {
  final QrRepository repository;

  UnlinkPetFromQrUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LinkPetToQrParams parameters) async {
    return await repository.unlinkPetFromQr(parameters.petId, parameters.qrCodeId);
  }


}
