import '../repositories/qr_repository.dart';
import '../../../pets/domain/entities/pet_entity.dart';

class ScanQrUseCase {
  final QrRepository repository;

  ScanQrUseCase(this.repository);

  Future<PetEntities?> call(String qrCodeId) async {
    return await repository.scanQr(qrCodeId);
  }
}
