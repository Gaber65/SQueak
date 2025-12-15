part of 'profile_mating_cubit.dart';

@immutable
sealed class ProfileMatingState {}

final class ProfileMatingInitial extends ProfileMatingState {}

final class ProfileChangeMatingLoading extends ProfileMatingState {}

final class ProfileChangeMatingSuccess extends ProfileMatingState {
  final String petId;

  ProfileChangeMatingSuccess(this.petId);
}

final class ProfileChangeMatingError extends ProfileMatingState {
  final String message;

  ProfileChangeMatingError(this.message);
}

final class ProfileGetMatingLoading extends ProfileMatingState {}

final class ProfileGetMatingSuccess extends ProfileMatingState {
  final PetEntities pet;

  ProfileGetMatingSuccess(this.pet);
}

final class ProfileGetMatingError extends ProfileMatingState {
  final String message;

  ProfileGetMatingError(this.message);
}

final class ProfileGetMatingHistoryLoading extends ProfileMatingState {}

final class ProfileGetMatingHistorySuccess extends ProfileMatingState {
  final List<HistoryEntity> history;

  ProfileGetMatingHistorySuccess(this.history);
}

final class ProfileGetMatingHistoryError extends ProfileMatingState {
  final String message;

  ProfileGetMatingHistoryError(this.message);
}
