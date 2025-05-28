import 'package:dio/dio.dart';
import 'package:squeak/features/auth/password/domin/entities/password_entity.dart';
import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/network/error_message_model.dart';
import '../datasources/password_remote_data_source.dart';
import 'package:dartz/dartz.dart';

class PasswordRepoImpl implements PasswordRepository {
  final PasswordRemoteDataSource remoteDataSource;

  PasswordRepoImpl({required this.remoteDataSource});

  @override
  Future<void> forgetPassword(String email) async {
    try {
      await remoteDataSource.forgetPassword(email);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }

  @override
  Future<void> resetPassword(PasswordEntity password) async {
    try {
      await remoteDataSource.resetPassword(
        password.email!,
        password.token!,
        password.newPassword!,
      );
    } on DioException catch (e) {
      throw left(
        ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
        ),
      );
    }
  }

  @override
  Future<void> verifyUser(String email, String token, String clinicCode) async {
    try {
      await remoteDataSource.verifyUser(email, token, clinicCode);
    } on DioException catch (e) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(e.response!.data),
      );
    }
  }
}
