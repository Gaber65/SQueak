import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';
import '../entities/appointment_entity.dart';

class GetAppointmentByIdParameters {
  final String id;

  GetAppointmentByIdParameters({required this.id});
}

class GetAppointmentByIdUseCase extends BaseUseCase<AppointmentEntity, GetAppointmentByIdParameters> {
  final AppointmentRepository repository;

  GetAppointmentByIdUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(GetAppointmentByIdParameters parameters) {
    return repository.getAppointmentById(parameters.id);
  }
} 