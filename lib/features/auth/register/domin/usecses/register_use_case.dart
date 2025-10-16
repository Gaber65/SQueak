import 'package:squeak/features/auth/register/domin/repositries/register_repository.dart';
import 'package:squeak/features/auth/login/data/models/auth_model.dart';

import '../entities/register_entity.dart';

class RegisterUseCase {
  final RegisterRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthModel> execute(RegisterEntity entity) async {
    return await repository.register(entity);
  }
}