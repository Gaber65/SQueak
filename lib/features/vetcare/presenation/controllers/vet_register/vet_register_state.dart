part of 'vet_register_cubit.dart';

abstract class VetRegisterState {}

class VetRegisterInitial extends VetRegisterState {}

// Register states
class LoadingRegisterState extends VetRegisterState {}
class SuccessRegisterState extends VetRegisterState {}
class ErrorRegisterState extends VetRegisterState {
  final ErrorMessageModel error;
  ErrorRegisterState(this.error);
}

// Login states
class LoadingLoginState extends VetRegisterState {}
class SuccessLoginState extends VetRegisterState {
  final LoginEntity authModel;
  final bool isHavePet;
  SuccessLoginState(this.authModel, this.isHavePet);
}
class ErrorLoginState extends VetRegisterState {
  final dynamic error;
  ErrorLoginState(this.error);
}

// Get client states
class LoadingGetClientState extends VetRegisterState {}
class SuccessGetClientState extends VetRegisterState {}
class ErrorGetClientState extends VetRegisterState {}

// Profile image states
class ProfileImagePickedSuccessState extends VetRegisterState {}
class ProfileImagePickedErrorState extends VetRegisterState {}