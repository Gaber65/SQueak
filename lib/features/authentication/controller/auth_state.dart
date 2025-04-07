part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class LoadingLoginState extends AuthState {}

class SuccessLoginState extends AuthState {
  final AuthModel userModel;

  SuccessLoginState(this.userModel);
}

class ErrorLoginState extends AuthState {
  final ResponseModel error;

  ErrorLoginState(this.error);
}

class ChangePasswordVisibilityState extends AuthState {}

class ChangePasswordLoadingState extends AuthState {}

class ChangePasswordSuccessState extends AuthState {}

class ChangePasswordErrorState extends AuthState {
  final ResponseModel error;

  ChangePasswordErrorState(this.error);
}

class ForgetPasswordLoadingState extends AuthState {}

class ForgetPasswordSuccessState extends AuthState {}

class ForgetPasswordErrorState extends AuthState {
  final ResponseModel error;

  ForgetPasswordErrorState(this.error);
}

class LoadingRegisterState extends AuthState {}

class SuccessRegisterState extends AuthState {}

class ErrorRegisterState extends AuthState {
  ResponseModel error;

  ErrorRegisterState(this.error);
}

class RestPasswordLoadingState extends AuthState {}

class RestPasswordSuccessState extends AuthState {
  final ResponseModel error;

  RestPasswordSuccessState(this.error);
}

class RestPasswordErrorState extends AuthState {
  final ResponseModel error;

  RestPasswordErrorState(this.error);
}

class VerifyUserLoadingState extends AuthState {}

class VerifyUserSuccessState extends AuthState {}

class VerifyUserErrorState extends AuthState {
  final ResponseModel error;
  VerifyUserErrorState(this.error);
}
class ContactUsLoadingState extends AuthState {}

class ContactUsSuccessState extends AuthState {}
class GetCountrySuccessState extends AuthState {}

class ContactUsErrorState extends AuthState {
  final ResponseModel error;
  ContactUsErrorState(this.error);
}


class FollowSuccess extends AuthState {
  final isHavePet;

  FollowSuccess(this.isHavePet);
}

class GetCurrentCountryCodeSuccessState extends AuthState {}
class GetCurrentCountryCodeLoadingState extends AuthState {}
class GetCurrentCountryCodeErrorState extends AuthState {}
