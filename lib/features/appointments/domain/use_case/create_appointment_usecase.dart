import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';
import '../entities/appointment_entity.dart';

class CreateAppointmentParameters {
  final AppointmentEntity appointment;

  CreateAppointmentParameters({required this.appointment});
}

class CreateAppointmentUseCase extends BaseUseCase<AppointmentEntity, CreateAppointmentParameters> {
  final AppointmentRepository repository;

  CreateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(CreateAppointmentParameters parameters) {
    return repository.createAppointment(parameters.appointment);
  }
} 