import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';


class GetUserAppointmentsUseCase implements BaseUseCase<List<AppointmentEntity>, GetUserAppointmentsParams> {
  final AppointmentRepository repository;

  GetUserAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(GetUserAppointmentsParams params) async {
    return await repository.getUserAppointments(params.phone, params.applyFilter);
  }
}

class GetUserAppointmentsParams extends Equatable {
  final String phone;
  final bool applyFilter;

  const GetUserAppointmentsParams({
    required this.phone,
    required this.applyFilter,
  });

  @override
  List<Object?> get props => [phone, applyFilter];
}