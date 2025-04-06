part of 'vaccination_cubit.dart';

abstract class VaccinationState {}

class VaccinationInitial extends VaccinationState {}

class AppChangeBottomSheetState extends VaccinationState {}

class AppCreateDatabaseState extends VaccinationState {}

class AppCreateDatabaseLoadingState extends VaccinationState {}

class AppGetDatabaseLoadingState extends VaccinationState {}

class AppGetDatabaseState extends VaccinationState {}

class AppUpDateDatabaseState extends VaccinationState {}

class AppDeleteDatabaseState extends VaccinationState {}

class AppInsertDatabaseState extends VaccinationState {}

class ChangeSettingModeState extends VaccinationState {}

class ChangeStateVacState extends VaccinationState {}

class GetVaccinationLoadingState extends VaccinationState {}

class GetVaccinationSuccessState extends VaccinationState {}

class GetPetVaccinationSuccessState extends VaccinationState {}

class GetVaccinationErrorState extends VaccinationState {
  String r;

  GetVaccinationErrorState(this.r);
}

class AddVaccinationLoadingState extends VaccinationState {}

class AddVaccinationSuccessState extends VaccinationState {}

class AddVaccinationErrorState extends VaccinationState {
  String r;

  AddVaccinationErrorState(this.r);
}

class GetVacPetsLoadingState extends VaccinationState {}

class GetVacPetsSuccessState extends VaccinationState {}

class GetVacPetsErrorState extends VaccinationState {
  String r;

  GetVacPetsErrorState(this.r);
}

class UpdateVacPetsLoadingState extends VaccinationState {}

class UpdateVacPetsSuccessState extends VaccinationState {}

class UpdateVacPetsErrorState extends VaccinationState {}

class DeleteVacPetsLoadingState extends VaccinationState {}

class DeleteVacPetsSuccessState extends VaccinationState {}

class DeleteVacPetsErrorState extends VaccinationState {
  final String r;

  DeleteVacPetsErrorState(this.r);
}

class TimeSelectedLoading extends VaccinationState {}
class TimeSelectedSuccessfully extends VaccinationState {}
class TimeSelectedError extends VaccinationState {}

class ChangeTheFreqValue extends VaccinationState {}
