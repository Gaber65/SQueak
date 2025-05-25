import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/error_message_model.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/entities/vaccination_entity.dart';
import '../../domain/repositories/vaccination_repository.dart';
import '../datasources/vaccination_local_data_source.dart';
import '../datasources/vaccination_remote_data_source.dart';
import '../models/reminder_model.dart';

class VaccinationRepositoryImpl implements VaccinationRepository {
  final VaccinationRemoteDataSource remoteDataSource;
  final VaccinationLocalDataSource localDataSource;

  VaccinationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<VaccinationNameEntity>>> getVaccinationNames() async {
    try {
      final result = await remoteDataSource.getVaccinationNames();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel));
    } on DioError catch (e) {
      return Left(ServerFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.message ?? 'Network error occurred',
          'success': false,
          'statusCode': e.response?.statusCode ?? 500,
        }),
      ));
    } catch (e) {
      return Left(ServerFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.toString(),
          'success': false,
          'statusCode': 500,
        }),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ReminderEntity>>> getPetReminders(String petId) async {
    try {
      final result = await localDataSource.getPetReminders(petId);
      return Right(result);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.errorMessage,
          'success': false,
          'statusCode': 500,
        }),
      ));
    } catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.toString(),
          'success': false,
          'statusCode': 500,
        }),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> createReminder(ReminderEntity reminder) async {
    try {
      final reminderModel = ReminderModel.fromEntity(reminder);
      await localDataSource.createReminder(reminderModel);
      return const Right(null);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.errorMessage,
          'success': false,
          'statusCode': 500,
        }),
      ));
    } catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.toString(),
          'success': false,
          'statusCode': 500,
        }),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateReminder(ReminderEntity reminder) async {
    try {
      final reminderModel = ReminderModel.fromEntity(reminder);
      await localDataSource.updateReminder(reminderModel);
      return const Right(null);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.errorMessage,
          'success': false,
          'statusCode': 500,
        }),
      ));
    } catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.toString(),
          'success': false,
          'statusCode': 500,
        }),
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReminder(int id) async {
    try {
      await localDataSource.deleteReminder(id);
      return const Right(null);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.errorMessage,
          'success': false,
          'statusCode': 500,
        }),
      ));
    } catch (e) {
      return Left(LocalDatabaseFailure(
        ErrorMessageModel.fromJson({
          'errors': {},
          'message': e.toString(),
          'success': false,
          'statusCode': 500,
        }),
      ));
    }
  }
}
