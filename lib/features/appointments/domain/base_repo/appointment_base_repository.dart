import 'package:dartz/dartz.dart';
import 'package:squeak/features/appointments/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/domain/entities/clinic_entity.dart';
import 'package:squeak/features/appointments/domain/entities/doctor_entity.dart';
import 'package:squeak/features/appointments/domain/use_case/create_appointment.dart';
import '../entities/client_clinic.dart';
import '../entities/invoice.dart';
import '../../../../core/utils/export_path/export_files.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<Availability>>> getAvailabilities(String clinicCode);
  Future<Either<Failure, MySupplier>> getSuppliers();
  Future<Either<Failure, List<Doctor>>> getDoctors(String clinicCode);
  Future<Either<Failure, List<PetClinic>>> getClientInClinic(String clinicCode, String phone);
  Future<Either<Failure, Unit>> createAppointment(CreateAppointmentParams pram);
  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments(String phone, bool applyFilter);
  Future<Either<Failure, Unit>> deleteAppointment(String appointmentId);
  Future<Either<Failure, Unit>> rateAppointment({
    required String appointmentId,
    required int cleanlinessRate,
    required int doctorServiceRate,
    required String feedbackComment,
  });
  Future<Either<Failure, Invoice>> getInvoice(String id);
}