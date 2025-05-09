import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';
import '../entities/appointment_entity.dart';

class GetAllAppointmentsUseCase extends BaseUseCase<List<AppointmentEntity>, NoParameters> {
  final AppointmentRepository repository;

  GetAllAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(NoParameters parameters) {
    return repository.getAllAppointments();
  }
} 