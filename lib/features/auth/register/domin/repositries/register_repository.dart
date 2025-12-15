import '../entities/country_entity.dart';
import '../entities/register_entity.dart';
import 'package:squeak/features/auth/login/data/models/auth_model.dart';

abstract class RegisterRepository {
  Future<List<CountryEntity>> getCountries(String name);
  Future<AuthModel> register(RegisterEntity entity);
  Future<AuthModel> registerWithQr(RegisterEntity entity, String clinicCode);
}
