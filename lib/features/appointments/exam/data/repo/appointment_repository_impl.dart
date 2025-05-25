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
  final AppointmentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Availability>>> getAvailabilities(
    String clinicCode,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAvailabilities = await remoteDataSource.getAvailabilities(
          clinicCode,
        );
        return Right(remoteAvailabilities);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
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
  }

  @override
  Future<Either<Failure, MySupplier>> getSuppliers() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSuppliers = await remoteDataSource.getSuppliers();
        await localDataSource.cacheSuppliers(remoteSuppliers);
        return Right(remoteSuppliers);
      } on ServerException catch (failure) {
        try {
          final localSuppliers = await localDataSource.getCachedSuppliers();
          if (localSuppliers != null) {
            return Right(localSuppliers);
          } else {
            return Left(LocalDatabaseFailure(
              ErrorMessageModel(
                message: 'No internet connection',
                statusCode: 0,
                errors: {},
                success: false,
              ),
            ),);
          }
        } on LocalDatabaseFailure {
          return Left(
            LocalDatabaseFailure(
              ErrorMessageModel(
                message: 'No internet connection',
                statusCode: 0,
                errors: {},
                success: false,
              ),
            ),
          );
        }
      }
    } else {
      try {
        final localSuppliers = await localDataSource.getCachedSuppliers();
        if (localSuppliers != null) {
          return Right(localSuppliers);
        } else {
          return Left(
            LocalDatabaseFailure(
              ErrorMessageModel(
                message: 'No internet connection',
                statusCode: 0,
                errors: {},
                success: false,
              ),
            ),
          );
        }
      } on LocalDatabaseFailure {
        return Left(
          LocalDatabaseFailure(
            ErrorMessageModel(
              message: 'No internet connection',
              statusCode: 0,
              errors: {},
              success: false,
            ),
          ),
        );
      }
    }
  }
  /// Silent background remote update
  Future<void> _updateFromRemote() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSuppliers = await remoteDataSource.getSuppliers();
        await localDataSource.cacheSuppliers(remoteSuppliers);
      } catch (_) {
        // Optional: log error or ignore
      }
    }
  }


  @override
  Future<Either<Failure, List<Doctor>>> getDoctors(String clinicCode) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDoctors = await remoteDataSource.getDoctors(clinicCode);
        return Right(remoteDoctors);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection',
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
    if (await networkInfo.isConnected) {
      try {
        final remoteClientClinic = await remoteDataSource.getClientInClinic(
          clinicCode,
          phone,
        );
        return Right(remoteClientClinic);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection',
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
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createAppointment(pram);
        return const Right(unit);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
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
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments(
      String phone,
      bool applyFilter,
      ) async {
    try {
      final localAppointments = await localDataSource.getCachedAppointments();
      if (localAppointments != null && localAppointments.isNotEmpty) {
        // Fire and forget remote update
        _updateAppointmentsFromRemote(phone, applyFilter);
        return Right(localAppointments);
      }
    } catch (_) {
      // Ignore local failure and try remote
    }

    // Local is empty or failed — fetch from remote directly
    return await _fetchAppointmentsFromRemote(phone, applyFilter);
  }

  /// Background update of appointments from remote
  Future<void> _updateAppointmentsFromRemote(
      String phone,
      bool applyFilter,
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAppointments = await remoteDataSource.getUserAppointments(
          phone,
          applyFilter,
        );
        await localDataSource.cacheAppointments(remoteAppointments);
      } catch (_) {
        // Silent fail/log
      }
    }
  }

  /// Fallback: fetch from remote and cache, or return failure
  Future<Either<Failure, List<AppointmentEntity>>> _fetchAppointmentsFromRemote(
      String phone,
      bool applyFilter,
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAppointments = await remoteDataSource.getUserAppointments(
          phone,
          applyFilter,
        );
        await localDataSource.cacheAppointments(remoteAppointments);
        return Right(remoteAppointments);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection',
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
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAppointment(appointmentId);
        return const Right(unit);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection',
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
    if (await networkInfo.isConnected) {
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
    } else {
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection',
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
    if (await networkInfo.isConnected) {
      try {
        final remoteInvoice = await remoteDataSource.getInvoice(id);
        return Right(remoteInvoice);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel));
      }
    } else {
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    }
  }
}
