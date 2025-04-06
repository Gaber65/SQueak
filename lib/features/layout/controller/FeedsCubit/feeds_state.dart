part of 'feeds_cubit.dart';

@immutable
sealed class FeedsState {}

final class FeedsInitial extends FeedsState {}


class GetPostLoadingState extends FeedsState {}

class PaginationLoadingState extends FeedsState {}

class GetPostSuccessState extends FeedsState {
  final PostModel postDoctorModel;

  GetPostSuccessState(this.postDoctorModel);
}

class GetPostErrorState extends FeedsState {}

class NoInternetConnection extends FeedsState {}

class PaginationErrorState extends FeedsState {}


class GetRefreshIndicatorState extends FeedsState {}

