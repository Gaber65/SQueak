

import 'package:squeak/features/profile_switch/domain/entities/profile_type_entity.dart';



abstract class SwitchProfileState {}

class ProfileInitial extends SwitchProfileState {}

class ProfileLoading extends SwitchProfileState {}

class ProfileLoaded extends SwitchProfileState {
  final ActiveProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends SwitchProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileSwitcherPage extends SwitchProfileState {
  final ActiveProfile profile;
  ProfileSwitcherPage(this.profile);
}
