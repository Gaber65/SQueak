part of 'vaccination_ui_cubit.dart';

abstract class VaccinationUiState extends Equatable {
  const VaccinationUiState();
  
  @override
  List<Object?> get props => [];
}

class VaccinationUiInitial extends VaccinationUiState {}

class VaccinationUiLoading extends VaccinationUiState {}

class VaccinationUiError extends VaccinationUiState {
  final String message;
  
  const VaccinationUiError(this.message);
  
  @override
  List<Object> get props => [message];
}

class VaccinationNamesLoaded extends VaccinationUiState {
  final List<VaccinationNameEntity> vaccinations;
  
  const VaccinationNamesLoaded(this.vaccinations);
  
  @override
  List<Object> get props => [vaccinations];
}

class PetRemindersLoaded extends VaccinationUiState {
  final List<ReminderEntity> reminders;
  
  const PetRemindersLoaded(this.reminders);
  
  @override
  List<Object> get props => [reminders];
}

class ReminderActionSuccess extends VaccinationUiState {}

class BottomSheetStateChanged extends VaccinationUiState {
  final bool isShown;
  
  const BottomSheetStateChanged(this.isShown);
  
  @override
  List<Object> get props => [isShown];
}

class ValueChanged extends VaccinationUiState {}

class SelectionChanged extends VaccinationUiState {
  final String vacName;
  final String vacId;
  
  const SelectionChanged(this.vacName, this.vacId);
  
  @override
  List<Object> get props => [vacName, vacId];
}

class DateChanged extends VaccinationUiState {
  final DateTime date;
  
  const DateChanged(this.date);
  
  @override
  List<Object> get props => [date];
}

class EditDateChanged extends VaccinationUiState {
  final DateTime date;
  
  const EditDateChanged(this.date);
  
  @override
  List<Object> get props => [date];
}

class TimeSelectionChanged extends VaccinationUiState {
  final bool isSelected;
  
  const TimeSelectionChanged(this.isSelected);
  
  @override
  List<Object> get props => [isSelected];
}

class TimePickerLoading extends VaccinationUiState {}

class TimePickerSuccess extends VaccinationUiState {
  final TimeOfDay time;
  
  const TimePickerSuccess(this.time);
  
  @override
  List<Object> get props => [time];
}

class TimePickerError extends VaccinationUiState {}

class FrequencyChanged extends VaccinationUiState {
  final String frequency;
  
  const FrequencyChanged(this.frequency);
  
  @override
  List<Object> get props => [frequency];
}

class FormReset extends VaccinationUiState {}
