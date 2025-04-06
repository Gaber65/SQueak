import 'package:squeak/core/utils/export_path/export_files.dart';


sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

final class GetAvailabilityLoading extends AppointmentState {}

final class GetAvailabilitySuccess extends AppointmentState {}

final class GetAvailabilityError extends AppointmentState {}

final class GetSupplierLoading extends AppointmentState {}

final class GetSupplierSuccess extends AppointmentState {}

final class GetSupplierError extends AppointmentState {}

final class GetDoctorLoading extends AppointmentState {}

final class GetDoctorSuccess extends AppointmentState {}

final class GetDoctorError extends AppointmentState {}

final class UnFollowLoading extends AppointmentState {}

final class UnFollowSuccess extends AppointmentState {}

final class UnFollowError extends AppointmentState {}

final class isNoSelectStatue extends AppointmentState {}

///todo Create Appointments
class CreateAppointmentsLoading extends AppointmentState {}

class CreateAppointmentsToVetICareSuccess extends AppointmentState {}

class CreateExistedClientAppointment extends AppointmentState {}

class CreateNewPetAppointment extends AppointmentState {}

class CreateNewPetAndClientAppointment extends AppointmentState {}

class CreateAppointmentsSuccess extends AppointmentState {}

class CreateAppointmentsError extends AppointmentState {
  final ErrorMessageModel errorMessageModel;

  CreateAppointmentsError(this.errorMessageModel);
}
