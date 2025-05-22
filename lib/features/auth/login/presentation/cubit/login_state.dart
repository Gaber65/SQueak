part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginEntity userEntity;

  const LoginSuccess(this.userEntity);

  @override
  List<Object> get props => [userEntity];
}

class LoginError extends LoginState {
  final ErrorMessageModel error;

  const LoginError(this.error);

  @override
  List<Object> get props => [error];
}