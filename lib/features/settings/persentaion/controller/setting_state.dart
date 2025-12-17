part of 'setting_cubit.dart';

@immutable
abstract class SettingState {}

class SettingInitial extends SettingState {}

class ChangeGenderState extends SettingState {}

class ChangeBirthdateState extends SettingState {}

class ChangeImageNameState extends SettingState {}

class GetOwnerDataLoading extends SettingState {}

class GetOwnerDataSuccess extends SettingState {}

class GetOwnerDataError extends SettingState {
  final String message;
  GetOwnerDataError(this.message);
}

class UpdateProfileLoadingState extends SettingState {}

class UpdateProfileSuccessState extends SettingState {
  final Owner owner;
  UpdateProfileSuccessState(this.owner);
}

class UpdateProfileErrorState extends SettingState {
  final String message;
  UpdateProfileErrorState(this.message);
}

class ProfileImagePickedSuccessState extends SettingState {}

class ProfileImagePickedErrorState extends SettingState {}

class UploadProfileImageLoadingState extends SettingState {}

class UploadProfileImageSuccessState extends SettingState {
  final String imageName;
  UploadProfileImageSuccessState(this.imageName);
}

class UploadProfileImageErrorState extends SettingState {
  final String message;
  UploadProfileImageErrorState(this.message);
}
