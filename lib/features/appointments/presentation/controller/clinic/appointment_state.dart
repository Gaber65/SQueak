part of 'appointment_cubit.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

// Availability States
class GetAvailabilityLoading extends AppointmentState {}
class GetAvailabilitySuccess extends AppointmentState {}
class GetAvailabilityError extends AppointmentState {}

// Supplier States
class GetSupplierLoading extends AppointmentState {}
class GetSupplierSuccess extends AppointmentState {}
class GetSupplierError extends AppointmentState {}
class SuppliersFiltered extends AppointmentState {}

// Unfollow Clinic States
class UnFollowLoading extends AppointmentState {}
class UnFollowSuccess extends AppointmentState {}
class UnFollowError extends AppointmentState {}

// Doctor States
class GetDoctorLoading extends AppointmentState {}
class GetDoctorSuccess extends AppointmentState {}
class GetDoctorError extends AppointmentState {}

// Client in Clinic States
class GetClientInClinicLoading extends AppointmentState {}
class GetClientInClinicSuccess extends AppointmentState {}
class GetClientInClinicError extends AppointmentState {}

// Create Appointment States
class CreateAppointmentsLoading extends AppointmentState {}
class CreateAppointmentsSuccess extends AppointmentState {}
class CreateAppointmentsError extends AppointmentState {
  final String errorMessageModel;
  const CreateAppointmentsError(this.errorMessageModel);
}
class CreateExistedClientAppointment extends AppointmentState {}
class CreateNewPetAppointment extends AppointmentState {}
class CreateNewPetAndClientAppointment extends AppointmentState {}

// Time Selection State
class TimeSelected extends AppointmentState {}

// No Select State
class NoSelectState extends AppointmentState {}


class UnfollowSuccess extends AppointmentState {}