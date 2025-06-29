import 'package:dartz/dartz.dart';

import '../../../../core/service/service_locator/locatore_export_path.dart';

abstract class QrRepository {
  Future<Either<Failure, bool>> linkPetToQr(String petId, String qrCodeId);
  Future<Either<Failure, bool>> unlinkPetFromQr(String petId, String qrCodeId);
}
