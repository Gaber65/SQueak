part of 'user_appointment_cubit.dart';

@immutable
sealed class UserAppointmentState {}

final class UserAppointmentInitial extends UserAppointmentState {}

final class GetAppointmentLoading extends UserAppointmentState {}

final class RateAppointmentLoading extends UserAppointmentState {}

final class RateAppointmentSuccess extends UserAppointmentState {}

final class RateAppointmentSuccessFunction extends UserAppointmentState {}

final class RateAppointmentError extends UserAppointmentState {}

final class GetAppointmentSuccess extends UserAppointmentState {}

final class GetAppointmentError extends UserAppointmentState {}

final class DeleteAppointmentLoading extends UserAppointmentState {}

final class DeleteAppointmentSuccess extends UserAppointmentState {}

final class DeleteAppointmentError extends UserAppointmentState {}

final class EditAppointment extends UserAppointmentState {
  final AppointmentModel model;

  EditAppointment(this.model);
}

final class AppointmentFiltered extends UserAppointmentState {
  final List<AppointmentModel> appointments;

  AppointmentFiltered(this.appointments);
}

final class AppointmentFilteredClear extends UserAppointmentState {
  final List<AppointmentModel> appointments;

  AppointmentFilteredClear(this.appointments);
}


final class ReceiptLoading extends UserAppointmentState {}

final class ReceiptSuccess extends UserAppointmentState {}

final class ReceiptError extends UserAppointmentState {}

final class GetSupplierLoading extends UserAppointmentState {}

final class GetSupplierSuccess extends UserAppointmentState {}

final class GetSupplierError extends UserAppointmentState {}

class FollowLoading extends UserAppointmentState {}

class FollowSuccess extends UserAppointmentState {}

class FollowError extends UserAppointmentState {
  final ResponseModel error;

  FollowError(this.error);
}

class GetInvoicesLoading extends UserAppointmentState {}

class GetInvoicesSuccess extends UserAppointmentState {}

class GetInvoicesError extends UserAppointmentState {
  final ResponseModel error;

  GetInvoicesError(this.error);
}
