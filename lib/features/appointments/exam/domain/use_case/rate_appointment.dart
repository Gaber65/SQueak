import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class RateAppointmentUseCase
    implements BaseUseCase<Unit, RateAppointmentParams> {
  final AppointmentRepository repository;

  RateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RateAppointmentParams params) async {
    return await repository.rateAppointment(
      appointmentId: params.appointmentId,
      cleanlinessRate: params.cleanlinessRate,
      doctorServiceRate: params.doctorServiceRate,
      feedbackComment: params.feedbackComment,
    );
  }
}

class RateAppointmentParams extends Equatable {
  final String appointmentId;
  final int cleanlinessRate;
  final int doctorServiceRate;
  final String feedbackComment;

  const RateAppointmentParams({
    required this.appointmentId,
    required this.cleanlinessRate,
    required this.doctorServiceRate,
    required this.feedbackComment,
  });

  @override
  List<Object?> get props => [
    appointmentId,
    cleanlinessRate,
    doctorServiceRate,
    feedbackComment,
  ];
}
