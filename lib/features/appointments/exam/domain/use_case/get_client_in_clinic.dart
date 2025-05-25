import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/client_clinic.dart';
import '../base_repo/appointment_base_repository.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';


class GetClientInClinicUseCase implements BaseUseCase<List<PetClinic>, GetClientInClinicParams> {
  final AppointmentRepository repository;

  GetClientInClinicUseCase(this.repository);

  @override
  Future<Either<Failure, List<PetClinic>>> call(GetClientInClinicParams params) async {
    return await repository.getClientInClinic(params.clinicCode, params.phone);
  }
}

class GetClientInClinicParams extends Equatable {
  final String clinicCode;
  final String phone;

  const GetClientInClinicParams({
    required this.clinicCode,
    required this.phone,
  });

  @override
  List<Object?> get props => [clinicCode, phone];
}