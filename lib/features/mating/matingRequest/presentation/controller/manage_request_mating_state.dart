part of 'manage_request_mating_cubit.dart';

@immutable
sealed class ManageRequestMatingState {}

final class ManageRequestMatingInitial extends ManageRequestMatingState {}

class GetMyMatingRequestLoading extends ManageRequestMatingState {}

class GetMyMatingRequestLoaded extends ManageRequestMatingState {
  final List<MatingRequestEntity> requests;
  GetMyMatingRequestLoaded(this.requests);
}

class GetMyMatingRequestError extends ManageRequestMatingState {
  final String message;
  GetMyMatingRequestError(this.message);
}

class UpdateMatingRequestLoading extends ManageRequestMatingState {}

class UpdateMatingRequestLoaded extends ManageRequestMatingState {
  final String message;
  UpdateMatingRequestLoaded(this.message);
}

class UpdateMatingRequestError extends ManageRequestMatingState {
  final String message;
  UpdateMatingRequestError(this.message);
}
