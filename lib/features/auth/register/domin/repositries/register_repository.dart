import '../entities/country_entity.dart';
import '../entities/register_entity.dart';

abstract class RegisterRepository {
  Future<List<CountryEntity>> getCountries(String name);
  Future<void> register(RegisterEntity entity);
  Future<void> registerWithQr(RegisterEntity entity, String clinicCode);
}