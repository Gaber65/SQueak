// features/auth/password/presentation/cubit/password_state.dart

part of 'password_cubit.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];
}

class PasswordInitial extends PasswordState {}

class ForgetPasswordLoadingState extends PasswordState {}

class ForgetPasswordSuccessState extends PasswordState {}

class ForgetPasswordErrorState extends PasswordState {
  final String error;
  const ForgetPasswordErrorState(this.error);
  @override
  List<Object> get props => [error];
}

class RestPasswordLoadingState extends PasswordState {}

class RestPasswordSuccessState extends PasswordState {}

class RestPasswordErrorState extends PasswordState {
  final String error;
  const RestPasswordErrorState(this.error);
  @override
  List<Object> get props => [error];
}

class VerifyUserLoadingState extends PasswordState {}

class VerifyUserSuccessState extends PasswordState {}

class VerifyUserErrorState extends PasswordState {
  final String error;
  const VerifyUserErrorState(this.error);
  @override
  List<Object> get props => [error];
}
