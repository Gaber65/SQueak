import '../repositories/qr_repository.dart';

class UnlinkPetFromQrUseCase {
  final QrRepository repository;

  UnlinkPetFromQrUseCase(this.repository);

  Future<bool> call(String petId) async {
    try {
      return await repository.unlinkPetFromQr(petId);
    } catch (e) {
      throw Exception('Failed to unlink pet from QR code: $e');
    }
  }
}
