part of 'follow_request_cubit.dart';

abstract class FollowRequestState {}

class FollowRequestInitial extends FollowRequestState {}

// Accept invitation states
class LoadingAcceptIvationState extends FollowRequestState {}

class SuccessAcceptIvationState extends FollowRequestState {
  final bool hasValidPets;
  SuccessAcceptIvationState(this.hasValidPets);
}

class ErrorAcceptIvationState extends FollowRequestState {
  final dynamic error;
  ErrorAcceptIvationState(this.error);
}

// Notification states
class NotificationsLoadingState extends FollowRequestState {}

class NotificationsSuccessState extends FollowRequestState {}

class NotificationsErrorState extends FollowRequestState {}

class LoadingGetClientState extends FollowRequestState {}

class SuccessGetClientState extends FollowRequestState {}

class ErrorGetClientState extends FollowRequestState {}
