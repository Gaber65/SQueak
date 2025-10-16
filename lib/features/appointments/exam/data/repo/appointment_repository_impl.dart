import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/client_clinic.dart';
import '../../domain/entities/invoice.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Availability>>> getAvailabilities(
    String clinicCode,
  ) async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      final remoteAvailabilities = await remoteDataSource.getAvailabilities(
        clinicCode,
      );
      return Right(remoteAvailabilities);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Failed to load availabilities: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, MySupplier>> getSuppliers() async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      final remoteSuppliers = await remoteDataSource.getSuppliers();
      return Right(remoteSuppliers);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Network error: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getDoctors(String clinicCode) async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      final remoteDoctors = await remoteDataSource.getDoctors(clinicCode);
      return Right(remoteDoctors);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Failed to load doctors: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PetClinic>>> getClientInClinic(
    String clinicCode,
    String phone,
  ) async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      final remoteClientClinic = await remoteDataSource.getClientInClinic(
        clinicCode,
        phone,
      );
      return Right(remoteClientClinic);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Network error: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> createAppointment(
    CreateAppointmentParams pram,
  ) async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      await remoteDataSource.createAppointment(pram);
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Network error: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments(
    String phone,
    bool applyFilter,
  ) async {
    final repoStart = DateTime.now();
    debugPrint('🔍 [Repository:getUserAppointments] START → ${repoStart.toIso8601String()}');

    // REMOVED: Slow network check (was taking 5 seconds!)
    // The Dio client will handle network errors automatically
    // If there's no connection, it will throw a DioException

    try {
      final dataSourceCallStart = DateTime.now();
      debugPrint('🔍 [Repository] Calling remoteDataSource → ${dataSourceCallStart.toIso8601String()}');
      
      final remoteAppointments = await remoteDataSource.getUserAppointments(
        phone,
        applyFilter,
      );
      
      final dataSourceCallEnd = DateTime.now();
      debugPrint('✅ [Repository] DataSource returned in ${dataSourceCallEnd.difference(dataSourceCallStart).inMilliseconds}ms');
      debugPrint('✅ [Repository] TOTAL TIME: ${dataSourceCallEnd.difference(repoStart).inMilliseconds}ms');
      
      return Right(remoteAppointments);
    } on ServerException catch (failure) {
      debugPrint('❌ [Repository] Server Error: ${failure.errorMessageModel.message}');
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      // Handle network connectivity errors here
      debugPrint('❌ [Repository] Network Error: $e');
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection or network error',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAppointment(String appointmentId) async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      await remoteDataSource.deleteAppointment(appointmentId);
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Network error: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> rateAppointment({
    required String appointmentId,
    required int cleanlinessRate,
    required int doctorServiceRate,
    required String feedbackComment,
  }) async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      await remoteDataSource.rateAppointment(
        appointmentId: appointmentId,
        cleanlinessRate: cleanlinessRate,
        doctorServiceRate: doctorServiceRate,
        feedbackComment: feedbackComment,
      );
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Network error: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Invoice>> getInvoice(String id) async {
    // REMOVED: Slow network check - Let Dio handle network errors
    try {
      final remoteInvoice = await remoteDataSource.getInvoice(id);
      return Right(remoteInvoice);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'Network error: $e',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }
}
