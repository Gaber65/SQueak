part of 'react_cubit.dart';

@immutable
abstract class ReactState {}

// Initial state
class ReactInitial extends ReactState {}

// --- States for fetching reactions ---
class GetReactionsLoading extends ReactState {}

class GetReactionsSuccess extends ReactState {
  final ReactionSummary reactions;

  GetReactionsSuccess({required this.reactions});
}

class GetReactionsFailure extends ReactState {
  final String error;

  GetReactionsFailure(this.error);
}

// --- States for creating/reacting on post ---
class CreateReactionLoading extends ReactState {}

class CreateReactionSuccess extends ReactState {
  final ReactionActionResult actionResult;

  CreateReactionSuccess({required this.actionResult});
}

class CreateReactionFailure extends ReactState {
  final String error;

  CreateReactionFailure(this.error);
}
