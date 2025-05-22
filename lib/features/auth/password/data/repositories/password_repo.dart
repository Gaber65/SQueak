// features/auth/password/data/repositories/password_repo_impl.dart


import 'package:dio/dio.dart';
import 'package:squeak/features/auth/password/domin/entities/password_entity.dart';
import 'package:squeak/features/auth/password/domin/password_failure.dart';
import 'package:squeak/features/auth/password/domin/repositries/password_repository.dart';

import '../datasources/password_remote_data_source.dart';
import 'package:dartz/dartz.dart';

class PasswordRepoImpl implements PasswordRepository {
  final PasswordRemoteDataSource remoteDataSource;

  PasswordRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<PasswordFailure, Unit>> forgetPassword(String email) async {
    try {
      await remoteDataSource.forgetPassword(email);
      return right(unit);
    } on DioException catch (e) {
      return left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<PasswordFailure, Unit>> resetPassword(PasswordEntity password) async {
    try {
      await remoteDataSource.resetPassword(
        password.email!,
        password.token!,
        password.newPassword!,
      );
      return right(unit);
    } on DioException catch (e) {
      return left(ServerFailure(e.response?.data['message'] ?? 'Password reset failed'));
    } catch (e) {
      return left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<PasswordFailure, Unit>> verifyUser(String email, String token) async {
    try {
      await remoteDataSource.verifyUser(email, token, '');
      return right(unit);
    } on DioException catch (e) {
      return left(ServerFailure(e.response?.data['message'] ?? 'Verification failed'));
    } catch (e) {
      return left(ServerFailure('An unexpected error occurred'));
    }
  }
}