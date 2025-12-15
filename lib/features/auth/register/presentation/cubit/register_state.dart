part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

// Initial state
class RegisterInitial extends RegisterState {}

// Form state
class RegisterFormUpdatedState extends RegisterState {}

// Country code detection states
class CountryCodeDetectionLoadingState extends RegisterState {}

class CountryCodeDetectionSuccessState extends RegisterState {}

class CountryCodeDetectionErrorState extends RegisterState {
  final String error;
  const CountryCodeDetectionErrorState(this.error);

  @override
  List<Object> get props => [error];
}

// Countries loading states
class CountriesLoadingState extends RegisterState {}

class CountriesLoadedState extends RegisterState {
  final List<CountryEntity> countries;
  const CountriesLoadedState(this.countries);

  @override
  List<Object> get props => [countries];
}

class CountriesErrorState extends RegisterState {
  final String error;
  const CountriesErrorState(this.error);

  @override
  List<Object> get props => [error];
}

// Registration states
class RegistrationLoadingState extends RegisterState {}

class RegistrationSuccessState extends RegisterState {}

class RegistrationErrorState extends RegisterState {
  final String error;
  const RegistrationErrorState(this.error);

  @override
  List<Object> get props => [error];
}
