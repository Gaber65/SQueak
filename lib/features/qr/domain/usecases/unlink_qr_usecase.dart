import '../repositories/qr_repository.dart';

class UnlinkQrUseCase {
  final QrRepository repository;

  UnlinkQrUseCase(this.repository);

  Future<bool> call(String petId) async {
    return await repository.unlinkQr(petId);
  }
}
