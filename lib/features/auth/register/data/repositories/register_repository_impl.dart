import 'package:dio/dio.dart';
import 'package:squeak/features/auth/register/data/datasources/register_remote_data_source.dart';
import 'package:squeak/features/auth/register/domin/entities/country_entity.dart';
import 'package:squeak/features/auth/register/domin/entities/register_entity.dart';
import 'package:squeak/features/auth/register/domin/repositries/register_repository.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CountryEntity>> getCountries(String name) async {
    final models = await remoteDataSource.getCountry(name);
    return models
        .map(
          (model) => CountryEntity(
            id: model.id,
            name: model.name,
            phoneCode: model.phoneCode,
          ),
        )
        .toList();
  }

  @override
  Future<void> register(RegisterEntity entity) async {
    try {
      await remoteDataSource.register(entity.toMapRegister());
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> registerWithQr(RegisterEntity entity, String clinicCode) async {
    try {
      await remoteDataSource.registerQr({
        ...entity.toMap(),
        'clinicCode': clinicCode,
      });
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
