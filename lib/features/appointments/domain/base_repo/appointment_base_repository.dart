import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getAllAppointments();
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByStatus(int status);
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(String id);
  Future<Either<Failure, AppointmentEntity>> createAppointment(AppointmentEntity appointment);
  Future<Either<Failure, AppointmentEntity>> updateAppointment(AppointmentEntity appointment);
  Future<Either<Failure, void>> deleteAppointment(String id);
  Future<Either<Failure, void>> checkInPet(String appointmentId, bool isCheckedIn);
  Future<Either<Failure, List<DoctorEntity>>> getClinicDoctors(String clinicId);
} 