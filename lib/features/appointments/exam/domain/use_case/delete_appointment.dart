import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../base_repo/appointment_base_repository.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class DeleteAppointmentUseCase implements BaseUseCase<Unit, DeleteAppointmentParams> {
  final AppointmentRepository repository;

  DeleteAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteAppointmentParams params) async {
    return await repository.deleteAppointment(params.appointmentId);
  }
}

class DeleteAppointmentParams extends Equatable {
  final String appointmentId;

  const DeleteAppointmentParams({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}