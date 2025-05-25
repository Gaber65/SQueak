import 'package:dartz/dartz.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/domain/entities/availability_entities.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';
import '../entities/client_clinic.dart';
import '../entities/invoice.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

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