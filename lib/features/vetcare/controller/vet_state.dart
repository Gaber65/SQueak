part of 'vet_cubit.dart';

@immutable
sealed class VetState {}

final class VetInitial extends VetState {}

class LoadingRegisterState extends VetState {}

class SuccessRegisterState extends VetState {}

class ErrorRegisterState extends VetState {
  final ResponseModel error;

  ErrorRegisterState(this.error);
}

class ChangeGenderState extends VetState {}

class ChangeBirthdateState extends VetState {}

class LoadingGetClientState extends VetState {}

class SuccessGetClientState extends VetState {}

class ErrorGetClientState extends VetState {}

class ProfileImagePickedSuccessState extends VetState {}

class ProfileImagePickedErrorState extends VetState {}

class LoadingGetClinicState extends VetState {}

class SuccessGetClinicState extends VetState {}

class ErrorGetClinicState extends VetState {}

class SuccessAcceptIvationState extends VetState {
  final isHavePet;

  SuccessAcceptIvationState(this.isHavePet);
}

class LoadingAcceptIvationState extends VetState {}

class ErrorAcceptIvationState extends VetState {
  final ResponseModel error;

  ErrorAcceptIvationState(this.error);
}

class LoadingLoginState extends VetState {}

class SuccessLoginState extends VetState {
  final AuthModel userModel;
  final isHavePet;

  SuccessLoginState(this.userModel, this.isHavePet);
}

class ErrorLoginState extends VetState {
  final ResponseModel error;

  ErrorLoginState(this.error);
}

class LoadingAddInSqueakStatuesState extends VetState {}

class SuccessAddInSqueakStatuesState extends VetState {
  final String id;

  SuccessAddInSqueakStatuesState(this.id);
}

class ErrorAddInSqueakStatuesState extends VetState {
  final ResponseModel error;

  ErrorAddInSqueakStatuesState(this.error);
}
final class NotificationsLoadingState extends VetState {}

final class NotificationsSuccessState extends VetState {}

final class NotificationsErrorState extends VetState {}


final class LoadingRemoveInSqueakStatuesState extends VetState {}

final class SuccessRemoveInSqueakStatuesState extends VetState {}

final class ErrorRemoveInSqueakStatuesState extends VetState {}
