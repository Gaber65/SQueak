
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:squeak/features/auth/login/domin/entities/login_entity.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/error_message_model.dart';
import '../../domain/base_repo/base_vet_repository.dart';
import '../../domain/entities/data_vet.dart';
import '../../domain/entities/vet_client.dart';
import '../data_sorce/base_vet_data_source.dart';

class VetRepository implements BaseVetRepository {
  final BaseVetRemoteDataSource remoteDataSource;

  VetRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<VetClient>>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String clientId,
    required String birthDate,
    required int gender,
    required String clinicCode,
    required int countryId,
  }) async {
    try {
      final result = await remoteDataSource.register(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        clientId: clientId,
        birthDate: birthDate,
        gender: gender,
        clinicCode: clinicCode,
        countryId: countryId,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorMessageModel.fromJson(e.response?.data)));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        emailOrPhone: emailOrPhone,
        password: password,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DataVetEntity>> getClient(
    String invitationCode,
  ) async {
    try {
      final result = await remoteDataSource.getClient(invitationCode);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorMessageModel.fromJson(e.response?.data)));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DataVetEntity>> getClientInApp(
    String code,
    String phone,
  ) async {
    try {
      final result = await remoteDataSource.getClientInApp(code, phone);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, dynamic>> getClinicById(String id) async {
    try {
      final result = await remoteDataSource.getClinicById(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<VetClient>>> getClientsFromVet(
    String code,
    String phone,
    bool isFilter,
  ) async {
    try {
      final result = await remoteDataSource.getClientsFromVet(
        code,
        phone,
        isFilter,
      );
      return Right(result);
    } on DioException catch (e) {
      // print(e.response?.data);
      return Left(ServerFailure(e.response?.data));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> addInSqueakStatues({
    required String vetCarePetId,
    String? squeakPetId,
    required int statuesOfAddingPetToSqueak,
  }) async {
    try {
      final result = await remoteDataSource.addInSqueakStatues(
        vetCarePetId: vetCarePetId,
        squeakPetId: squeakPetId,
        statuesOfAddingPetToSqueak: statuesOfAddingPetToSqueak,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorMessageModel.fromJson(e.response?.data)));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> acceptInvitation({
    required String clinicCode,
    required String clientId,
    required String squeakUserId,
  }) async {
    try {
      final result = await remoteDataSource.acceptInvitation(
        clinicCode: clinicCode,
        clientId: clientId,
        squeakUserId: squeakUserId,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorMessageModel.fromJson(e.response?.data)));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getNotifications(String id) async {
    try {
      final result = await remoteDataSource.getNotifications(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationState(String id) async {
    try {
      final result = await remoteDataSource.updateNotificationState(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: e.toString(),
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }
}
