import 'package:dio/dio.dart';
import 'package:squeak/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';
import 'package:squeak/features/auth/login/domin/repositries/log_repositry.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/network/error_message_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginEntity> login({
    required String emailOrPhoneNumber,
    required String password,
  }) async {
    try {
      final model = await remoteDataSource.login(
        emailOrPhoneNumber: emailOrPhoneNumber,
        password: password,
      );

      return LoginEntity(
        token: model.data?.token ?? '',
        refreshToken: model.data?.refreshToken ?? '',
        id: model.data?.id ?? '',
        fullName: model.data?.fullName ?? '',
        email: model.data?.email ?? '',
        phone: model.data?.phone ?? '',
        role: model.data?.role ?? 0,
        expiresIn: model.data?.expiresIn ?? DateTime.now(),
      );
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
