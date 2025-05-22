import 'package:squeak/features/auth/register/domin/repositries/register_repository.dart';

import '../entities/register_entity.dart';

class RegisterQrUseCase {
  final RegisterRepository repository;

  RegisterQrUseCase(this.repository);

  Future<void> execute(RegisterEntity entity, String clinicCode) async {
    return await repository.registerWithQr(entity, clinicCode);
  }
}