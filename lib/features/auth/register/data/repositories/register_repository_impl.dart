import 'package:squeak/features/auth/register/data/datasources/register_remote_data_source.dart';
import 'package:squeak/features/auth/register/domin/entities/country_entity.dart';
import 'package:squeak/features/auth/register/domin/entities/register_entity.dart';
import 'package:squeak/features/auth/register/domin/repositries/register_repository.dart';


class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CountryEntity>> getCountries(String name) async {
    final models = await remoteDataSource.getCountry(name);
    return models.map((model) => CountryEntity(
      id: model.id,
      name: model.name,
      phoneCode: model.phoneCode,
    )).toList();
  }

  @override
  Future<void> register(RegisterEntity entity) async {
    await remoteDataSource.register(entity.toMap());
  }

  @override
  Future<void> registerWithQr(RegisterEntity entity, String clinicCode) async {
    await remoteDataSource.registerQr({
      ...entity.toMap(),
      'clinicCode': clinicCode,
    });
  }
}