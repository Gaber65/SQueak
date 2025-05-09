import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';

class DeleteAppointmentParameters {
  final String id;

  DeleteAppointmentParameters({required this.id});
}

class DeleteAppointmentUseCase extends BaseUseCase<void, DeleteAppointmentParameters> {
  final AppointmentRepository repository;

  DeleteAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAppointmentParameters parameters) {
    return repository.deleteAppointment(parameters.id);
  }
} 