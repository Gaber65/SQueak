import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';

class CheckInPetParameters {
  final String appointmentId;
  final bool isCheckedIn;

  CheckInPetParameters({
    required this.appointmentId,
    required this.isCheckedIn,
  });
}

class CheckInPetUseCase extends BaseUseCase<void, CheckInPetParameters> {
  final AppointmentRepository repository;

  CheckInPetUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CheckInPetParameters parameters) {
    return repository.checkInPet(
      parameters.appointmentId,
      parameters.isCheckedIn,
    );
  }
} 