import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';
import '../entities/appointment_entity.dart';

class UpdateAppointmentParameters {
  final AppointmentEntity appointment;

  UpdateAppointmentParameters({required this.appointment});
}

class UpdateAppointmentUseCase extends BaseUseCase<AppointmentEntity, UpdateAppointmentParameters> {
  final AppointmentRepository repository;

  UpdateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(UpdateAppointmentParameters parameters) {
    return repository.updateAppointment(parameters.appointment);
  }
} 