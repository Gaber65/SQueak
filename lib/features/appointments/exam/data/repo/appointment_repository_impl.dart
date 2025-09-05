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
    try {
      // Step 1: Get from local cache first
      final cachedAvailabilities = await localDataSource.getCachedAvailabilities(clinicCode);

      // Step 2: Start fetching from remote in background to update cache
      if (await networkInfo.isConnected) {
        try {
          final remoteAvailabilities = await remoteDataSource.getAvailabilities(clinicCode);
          await localDataSource.cacheAvailabilities(clinicCode, remoteAvailabilities);
          
          // Return fresh data from remote
          return Right(remoteAvailabilities);
        } catch (_) {
          // If remote fails but we have cached data, return cached
          if (cachedAvailabilities != null) {
            return Right(cachedAvailabilities);
          }
          rethrow;
        }
      }

      // Step 3: Return cached data if available (offline case)
      if (cachedAvailabilities != null) {
        return Right(cachedAvailabilities);
      }

      // Step 4: No cache and no internet
      return Left(
        ServerFailure(
          ErrorMessageModel(
            message: 'No internet connection and no cached data available',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    } on ServerException catch (failure) {
      // Try to return cached data if server fails
      try {
        final cachedAvailabilities = await localDataSource.getCachedAvailabilities(clinicCode);
        if (cachedAvailabilities != null) {
          return Right(cachedAvailabilities);
        }
      } catch (_) {
        // Ignore cache errors
      }
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
    try {
      // Step 1: Get from local first
      final localSuppliers = await localDataSource.getCachedSuppliers();

      // Step 2: Start fetching from remote in background (optional if you want freshness)
      try {
        final remoteSuppliers = await remoteDataSource.getSuppliers();
        await localDataSource.cacheSuppliers(remoteSuppliers);
      } catch (_) {
        // Optional: ignore failure or log it
      }

      // Step 3: Return local data if found
      if (localSuppliers != null) {
        return Right(localSuppliers);
      }

      // Step 4: If local is null, fallback to remote (in case first try failed)
      final remoteSuppliers = await remoteDataSource.getSuppliers();
      await localDataSource.cacheSuppliers(remoteSuppliers);
      return Right(remoteSuppliers);

    } on ServerException catch (_) {
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
    } on LocalDatabaseFailure {
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'Failed to load local data',
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
    try {
      // Step 1: Get from local cache first
      final cachedDoctors = await localDataSource.getCachedDoctors(clinicCode);

      // Step 2: Start fetching from remote in background to update cache
      if (await networkInfo.isConnected) {
        try {
          final remoteDoctors = await remoteDataSource.getDoctors(clinicCode);
          await localDataSource.cacheDoctors(clinicCode, remoteDoctors);
          
          // Return fresh data from remote
          return Right(remoteDoctors);
        } catch (_) {
          // If remote fails but we have cached data, return cached
          if (cachedDoctors != null) {
            return Right(cachedDoctors);
          }
          rethrow;
        }
      }

      // Step 3: Return cached data if available (offline case)
      if (cachedDoctors != null) {
        return Right(cachedDoctors);
      }

      // Step 4: No cache and no internet
      return Left(
        LocalDatabaseFailure(
          ErrorMessageModel(
            message: 'No internet connection and no cached data available',
            statusCode: 0,
            errors: {},
            success: false,
          ),
        ),
      );
    } on ServerException catch (failure) {
      // Try to return cached data if server fails
      try {
        final cachedDoctors = await localDataSource.getCachedDoctors(clinicCode);
        if (cachedDoctors != null) {
          return Right(cachedDoctors);
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(ServerFailure(failure.errorMessageModel));
    } catch (e) {
      return Left(
        LocalDatabaseFailure(
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
      // Step 1: Try local cache
      final localAppointments = await localDataSource.getCachedAppointments();

      if (localAppointments.isNotEmpty) {
        // Step 2: Start remote update in background (no need to wait)
        unawaited(_updateAppointmentsFromRemote(phone, applyFilter));

        // Step 3: Return local immediately
        return Right(localAppointments);
      }
    } catch (_) {
      // Step 4: If local fails, continue to remote
    }

    // Step 5: Local failed or empty — fallback to remote
    return await _fetchAppointmentsFromRemote(phone, applyFilter);
  }

  /// Update from remote source and cache it silently
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
        // Optional: add logging here if needed
      }
    }
  }

  /// Fallback remote fetch
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
