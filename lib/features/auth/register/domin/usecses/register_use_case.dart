import 'package:squeak/features/auth/register/domin/repositries/register_repository.dart';

import '../entities/register_entity.dart';

class RegisterUseCase {
  final RegisterRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(RegisterEntity entity) async {
    return await repository.register(entity);
  }
}