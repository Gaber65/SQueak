part of 'post_cubit.dart';


sealed class PostState {}

final class PostInitial extends PostState {}




class GetPostLoadingState extends PostState {}

class PaginationLoadingState extends PostState {}
class GetPostSuccessState extends PostState {}
class GetPostErrorState extends PostState {}
class NoInternetConnection extends PostState {}
class PaginationErrorState extends PostState {}
class GetRefreshIndicatorState extends PostState {}


class CreatePostLoadingState extends PostState {}
class CreatePostSuccessState extends PostState {}
class CreatePostErrorState extends PostState {
  final String message;
  CreatePostErrorState(this.message);
}

class DeletePostLoadingState extends PostState {}
class DeletePostSuccessState extends PostState {}
class DeletePostErrorState extends PostState {
  final String message;
  DeletePostErrorState(this.message);
}


class GetReactionsLoading extends PostState {}

class GetReactionsSuccess extends PostState {
  final ReactionSummary reactions;

  GetReactionsSuccess({required this.reactions});
}

class GetReactionsFailure extends PostState {
  final String error;

  GetReactionsFailure(this.error);
}

// --- States for creating/reacting on post ---
class CreateReactionLoading extends PostState {}

class CreateReactionSuccess extends PostState {
  final ReactionActionResult actionResult;

  CreateReactionSuccess({required this.actionResult});
}

class CreateReactionFailure extends PostState {
  final String error;

  CreateReactionFailure(this.error);
}
