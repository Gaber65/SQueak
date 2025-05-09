import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../../domain/base_repo/appointment_base_repository.dart';
import '../../domain/entities/appointment_entity.dart';
import '../data_source/appointment_local_data_source.dart';
import '../data_source/appointment_remote_data_source.dart';
import '../models/appointment_model.dart';

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
  Future<Either<Failure, List<AppointmentEntity>>> getAllAppointments() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAppointments = await remoteDataSource.getAllAppointments();
        await localDataSource.cacheAppointments(remoteAppointments);
        return Right(remoteAppointments.map((e) => e).toList());
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      try {
        final localAppointments = await localDataSource.getCachedAppointments();
        return Right(localAppointments.map((e) => e).toList());
      } on LocalDatabaseException catch (failure) {
        return Left(LocalDatabaseFailure(failure.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByStatus(int status) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAppointments = await remoteDataSource.getAppointmentsByStatus(status);
        return Right(remoteAppointments.map((e) => e).toList());
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      try {
        final localAppointments = await localDataSource.getCachedAppointments();
        final filteredAppointments = localAppointments.where((e) => e.status == status).toList();
        return Right(filteredAppointments.map((e) => e).toList());
      } on LocalDatabaseException catch (failure) {
        return Left(LocalDatabaseFailure(failure.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAppointment = await remoteDataSource.getAppointmentById(id);
        return Right(remoteAppointment);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      try {
        final localAppointments = await localDataSource.getCachedAppointments();
        final appointment = localAppointments.firstWhere((e) => e.id == id);
        return Right(appointment);
      } on LocalDatabaseException catch (failure) {
        return Left(LocalDatabaseFailure(failure.errorMessage));
      } catch (e) {
        return Left(LocalDatabaseFailure('Appointment not found'));
      }
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(AppointmentEntity appointment) async {
    if (await networkInfo.isConnected) {
      try {
        final appointmentData = AppointmentData(
          id: appointment.id,
          petId: appointment.petId,
          clientId: appointment.clientId,
          doctorId: appointment.doctorId,
          clinicId: appointment.clinicId,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
          appointmentDate: appointment.appointmentDate,
          note: appointment.note,
          status: appointment.status,
          reason: appointment.reason,
          isPetCheckIn: appointment.isPetCheckIn,
          createDate: appointment.createDate,
          doctor: appointment.doctor,
          pet: appointment.pet,
          clinic: appointment.clinic,
        );

        final remoteAppointment = await remoteDataSource.createAppointment(appointmentData);
        final appointments = await localDataSource.getCachedAppointments();
        appointments.add(remoteAppointment);
        await localDataSource.cacheAppointments(appointments);

        return Right(remoteAppointment);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> updateAppointment(AppointmentEntity appointment) async {
    if (await networkInfo.isConnected) {
      try {
        final appointmentData = AppointmentData(
          id: appointment.id,
          petId: appointment.petId,
          clientId: appointment.clientId,
          doctorId: appointment.doctorId,
          clinicId: appointment.clinicId,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
          appointmentDate: appointment.appointmentDate,
          note: appointment.note,
          status: appointment.status,
          reason: appointment.reason,
          isPetCheckIn: appointment.isPetCheckIn,
          createDate: appointment.createDate,
          doctor: appointment.doctor,
          pet: appointment.pet,
          clinic: appointment.clinic,
        );

        final remoteAppointment = await remoteDataSource.updateAppointment(appointmentData);
        final appointments = await localDataSource.getCachedAppointments();
        final index = appointments.indexWhere((a) => a.id == appointment.id);
        
        if (index != -1) {
          appointments[index] = remoteAppointment;
          await localDataSource.cacheAppointments(appointments);
        }

        return Right(remoteAppointment);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAppointment(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAppointment(id);
        final appointments = await localDataSource.getCachedAppointments();
        appointments.removeWhere((a) => a.id == id);
        await localDataSource.cacheAppointments(appointments);

        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> checkInPet(String appointmentId, bool isCheckedIn) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.checkInPet(appointmentId, isCheckedIn);
        final appointments = await localDataSource.getCachedAppointments();
        final index = appointments.indexWhere((a) => a.id == appointmentId);
        
        if (index != -1) {
          final updatedAppointment = AppointmentData(
            id: appointments[index].id,
            petId: appointments[index].petId,
            clientId: appointments[index].clientId,
            doctorId: appointments[index].doctorId,
            clinicId: appointments[index].clinicId,
            startTime: appointments[index].startTime,
            endTime: appointments[index].endTime,
            appointmentDate: appointments[index].appointmentDate,
            note: appointments[index].note,
            status: appointments[index].status,
            reason: appointments[index].reason,
            isPetCheckIn: isCheckedIn,
            createDate: appointments[index].createDate,
            doctor: appointments[index].doctor,
            pet: appointments[index].pet,
            clinic: appointments[index].clinic,
          );
          
          appointments[index] = updatedAppointment;
          await localDataSource.cacheAppointments(appointments);
        }

        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> getClinicDoctors(String clinicId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDoctors = await remoteDataSource.getClinicDoctors(clinicId);
        await localDataSource.cacheDoctors(remoteDoctors);
        return Right(remoteDoctors.map((e) => e).toList());
      } on ServerException catch (failure) {
        return Left(ServerFailure(failure.errorMessageModel.message));
      }
    } else {
      try {
        final localDoctors = await localDataSource.getCachedDoctors();
        return Right(localDoctors.map((e) => e).toList());
      } on LocalDatabaseException catch (failure) {
        return Left(LocalDatabaseFailure(failure.errorMessage));
      }
    }
  }
} 