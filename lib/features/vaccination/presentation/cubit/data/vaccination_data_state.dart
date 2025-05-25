part of 'vaccination_data_cubit.dart';

abstract class VaccinationDataState extends Equatable {
  const VaccinationDataState();
  
  @override
  List<Object> get props => [];
}

class VaccinationDataInitial extends VaccinationDataState {}

// Get Vaccination Names States
class GetVaccinationNamesLoading extends VaccinationDataState {}

class GetVaccinationNamesSuccess extends VaccinationDataState {
  final List<VaccinationNameEntity> vaccinations;

  const GetVaccinationNamesSuccess(this.vaccinations);
  
  @override
  List<Object> get props => [vaccinations];
}

class GetVaccinationNamesError extends VaccinationDataState {
  final String message;

  const GetVaccinationNamesError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Get Pet Reminders States
class GetPetRemindersLoading extends VaccinationDataState {}

class GetPetRemindersSuccess extends VaccinationDataState {
  final List<ReminderEntity> reminders;

  const GetPetRemindersSuccess(this.reminders);
  
  @override
  List<Object> get props => [reminders];
}

class GetPetRemindersError extends VaccinationDataState {
  final String message;

  const GetPetRemindersError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Create Reminder States
class CreateReminderLoading extends VaccinationDataState {}

class CreateReminderSuccess extends VaccinationDataState {
  final String petId;

  const CreateReminderSuccess(this.petId);
}

class CreateReminderError extends VaccinationDataState {
  final String message;

  const CreateReminderError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Update Reminder States
class UpdateReminderLoading extends VaccinationDataState {}

class UpdateReminderSuccess extends VaccinationDataState {}

class UpdateReminderError extends VaccinationDataState {
  final String message;

  const UpdateReminderError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Delete Reminder States
class DeleteReminderLoading extends VaccinationDataState {}

class DeleteReminderSuccess extends VaccinationDataState {}

class DeleteReminderError extends VaccinationDataState {
  final String message;

  const DeleteReminderError(this.message);
  
  @override
  List<Object> get props => [message];
}
