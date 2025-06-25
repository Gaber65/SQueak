import '../repositories/qr_repository.dart';

class LinkQrUseCase {
  final QrRepository repository;

  LinkQrUseCase(this.repository);

  Future<bool> call(String petId, String qrCodeId) async {
    return await repository.linkQr(petId, qrCodeId);
  }
}
