import 'package:dartz/dartz.dart';
import 'package:squeak/features/qr/domain/usecases/link_pet_to_qr_usecase.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';
import '../repositories/qr_repository.dart';

class UnlinkPetFromQrUseCase extends BaseUseCase<bool, LinkPetToQrParams> {
  final QrRepository repository;

  UnlinkPetFromQrUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LinkPetToQrParams parameters) async {
    return await repository.unlinkPetFromQr(parameters.petId, parameters.qrCodeId);
  }


}
