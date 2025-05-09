import 'package:dartz/dartz.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../base_repo/appointment_base_repository.dart';
import '../entities/appointment_entity.dart';

class GetClinicDoctorsParameters {
  final String clinicId;

  GetClinicDoctorsParameters({required this.clinicId});
}

class GetClinicDoctorsUseCase extends BaseUseCase<List<DoctorEntity>, GetClinicDoctorsParameters> {
  final AppointmentRepository repository;

  GetClinicDoctorsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(GetClinicDoctorsParameters parameters) {
    return repository.getClinicDoctors(parameters.clinicId);
  }
} 