import 'dart:async';
import 'package:dartz/dartz.dart';
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
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

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
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

    try {
      final remoteSuppliers = await remoteDataSource.getSuppliers();
      return Right(remoteSuppliers);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<Doctor>>> getDoctors(String clinicCode) async {
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

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
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

    try {
      final remoteClientClinic = await remoteDataSource.getClientInClinic(
        clinicCode,
        phone,
      );
      return Right(remoteClientClinic);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, Unit>> createAppointment(
    CreateAppointmentParams pram,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

    try {
      await remoteDataSource.createAppointment(pram);
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments(
    String phone,
    bool applyFilter,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

    try {
      final remoteAppointments = await remoteDataSource.getUserAppointments(
        phone,
        applyFilter,
      );
      return Right(remoteAppointments);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAppointment(String appointmentId) async {
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

    try {
      await remoteDataSource.deleteAppointment(appointmentId);
      return const Right(unit);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }

  @override
  Future<Either<Failure, Unit>> rateAppointment({
    required String appointmentId,
    required int cleanlinessRate,
    required int doctorServiceRate,
    required String feedbackComment,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

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
    }
  }

  @override
  Future<Either<Failure, Invoice>> getInvoice(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }

    try {
      final remoteInvoice = await remoteDataSource.getInvoice(id);
      return Right(remoteInvoice);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel));
    }
  }
}
