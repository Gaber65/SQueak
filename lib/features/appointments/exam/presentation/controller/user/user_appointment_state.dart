part of 'user_appointment_cubit.dart';

abstract class UserAppointmentState extends Equatable {
  const UserAppointmentState();

  @override
  List<Object?> get props => [];
}

class UserAppointmentInitial extends UserAppointmentState {}

// Appointment States
class GetAppointmentLoading extends UserAppointmentState {}

class GetAppointmentSuccess extends UserAppointmentState {}

class GetAppointmentError extends UserAppointmentState {}

// Delete Appointment States
class DeleteAppointmentLoading extends UserAppointmentState {}

class DeleteAppointmentSuccess extends UserAppointmentState {
  final String id;

  const DeleteAppointmentSuccess(this.id);
}

class DeleteAppointmentError extends UserAppointmentState {}

// Rate Appointment States
class RateAppointmentLoading extends UserAppointmentState {}

class RateAppointmentSuccess extends UserAppointmentState {}

class RateAppointmentError extends UserAppointmentState {}

class RatingInitialized extends UserAppointmentState {}

// Supplier States
class GetSupplierLoading extends UserAppointmentState {}

class GetSupplierSuccess extends UserAppointmentState {}

class GetSupplierError extends UserAppointmentState {}

// Follow Clinic States
class FollowLoading extends UserAppointmentState {}

class FollowSuccess extends UserAppointmentState {}

class FollowError extends UserAppointmentState {}

// Invoice States
class GetInvoicesLoading extends UserAppointmentState {}

class GetInvoicesSuccess extends UserAppointmentState {}

class GetInvoicesError extends UserAppointmentState {
  final String message;

  const GetInvoicesError(this.message);
}

// Filter States
class AppointmentFiltered extends UserAppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentFiltered(this.appointments);
}

class AppointmentFilterCleared extends UserAppointmentState {}
class ShowFloatButton extends UserAppointmentState {}

class EditAppointment extends UserAppointmentState {
  final AppointmentEntity model;
  const EditAppointment(this.model);
}
