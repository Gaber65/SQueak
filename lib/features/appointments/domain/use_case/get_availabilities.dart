import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:squeak/features/appointments/domain/entities/availability_entities.dart';
import '../../../../core/utils/export_path/export_files.dart';

import '../base_repo/appointment_base_repository.dart';


class GetAvailabilitiesUseCase implements BaseUseCase<List<Availability>, GetAvailabilitiesParams> {
  final AppointmentRepository repository;

  GetAvailabilitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Availability>>> call(GetAvailabilitiesParams params) async {
    return await repository.getAvailabilities(params.clinicCode);
  }
}

class GetAvailabilitiesParams extends Equatable {
  final String clinicCode;

  const GetAvailabilitiesParams({required this.clinicCode});

  @override
  List<Object?> get props => [clinicCode];
}