import '../repositories/qr_repository.dart';

class LinkPetToQrUseCase {
  final QrRepository repository;

  LinkPetToQrUseCase(this.repository);

  Future<bool> call(String petId, String qrCodeId) async {
    try {
      return await repository.linkPetToQr(petId, qrCodeId);
    } catch (e) {
      throw Exception('Failed to link pet to QR code: $e');
    }
  }
}
