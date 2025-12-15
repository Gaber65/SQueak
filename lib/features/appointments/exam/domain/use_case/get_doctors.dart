import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';

import '../../../../../core/service/service_locator/locatore_export_path.dart';

class GetDoctorsUseCase implements BaseUseCase<List<Doctor>, GetDoctorsParams> {
  final AppointmentRepository repository;

  GetDoctorsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Doctor>>> call(GetDoctorsParams params) async {
    return await repository.getDoctors(params.clinicCode);
  }
}

class GetDoctorsParams extends Equatable {
  final String clinicCode;

  const GetDoctorsParams({required this.clinicCode});

  @override
  List<Object?> get props => [clinicCode];
}
