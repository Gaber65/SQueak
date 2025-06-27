import '../repositories/qr_repository.dart';

class DownloadQrUseCase {
  final QrRepository repository;

  DownloadQrUseCase(this.repository);

  Future<bool> call(String qrCodeId, String petName) async {
    try {
      return await repository.downloadQrCode(qrCodeId, petName);
    } catch (e) {
      throw Exception('Failed to download QR code: $e');
    }
  }
}
