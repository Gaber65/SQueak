part of 'setting_cubit.dart';

@immutable
sealed class SettingState {}

final class SettingInitial extends SettingState {}

final class ChangeGenderState extends SettingState {}

final class ChangeBirthdateState extends SettingState {}

final class ChangeImageNameState extends SettingState {}

final class ProfileImagePickedSuccessState extends SettingState {}

final class ProfileImagePickedErrorState extends SettingState {}

final class UpdateProfileLoadingState extends SettingState {}

final class UpdateProfileSuccessState extends SettingState {
  final OwnerModel userModel;

  UpdateProfileSuccessState(this.userModel);
}

final class UpdateProfileErrorState extends SettingState {
  final String error;

  UpdateProfileErrorState(this.error);
}
