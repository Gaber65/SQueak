import '../entities/qr_code_entity.dart';
import '../repositories/qr_repository.dart';

class GetQrByPetUseCase {
  final QrRepository repository;

  GetQrByPetUseCase(this.repository);

  Future<QrCodeEntity?> call(String petId) async {
    try {
      return await repository.getQrCodeByPetId(petId);
    } catch (e) {
      throw Exception('Failed to get QR code: $e');
    }
  }
}
