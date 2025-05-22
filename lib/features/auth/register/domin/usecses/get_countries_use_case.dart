import 'package:squeak/features/auth/register/domin/repositries/register_repository.dart';

import '../entities/country_entity.dart';

class GetCountriesUseCase {
  final RegisterRepository repository;

  GetCountriesUseCase(this.repository);

  Future<List<CountryEntity>> execute(String name) async {
    return await repository.getCountries(name);
  }
}