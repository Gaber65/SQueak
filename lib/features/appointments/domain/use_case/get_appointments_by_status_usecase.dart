import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';
import '../entities/appointment_entity.dart';

class GetAppointmentsByStatusParameters {
  final int status;

  GetAppointmentsByStatusParameters({required this.status});
}

class GetAppointmentsByStatusUseCase extends BaseUseCase<List<AppointmentEntity>, GetAppointmentsByStatusParameters> {
  final AppointmentRepository repository;

  GetAppointmentsByStatusUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetAppointmentsByStatusParameters parameters) {
    return repository.getAppointmentsByStatus(parameters.status);
  }
} 