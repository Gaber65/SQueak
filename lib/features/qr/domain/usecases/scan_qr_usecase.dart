import '../repositories/qr_repository.dart';
import '../../../pets/domain/entities/pet_entity.dart';

class ScanQrUseCase {
  final QrRepository repository;

  ScanQrUseCase(this.repository);

  Future<PetEntities?> call(String qrCodeId) async {
    try {
      // First validate the QR code
      final isValid = await repository.validateQrCode(qrCodeId);
      if (!isValid) {
        throw Exception('This QR code is not a valid Squeak code');
      }

      // Get pet data
      final pet = await repository.getPetByQrCode(qrCodeId);

      // Send scan notification if pet exists
      if (pet != null) {
        await repository.sendScanNotification(qrCodeId, pet.petId);
      }

      return pet;
    } catch (e) {
      throw Exception('Failed to scan QR code: $e');
    }
  }
}
