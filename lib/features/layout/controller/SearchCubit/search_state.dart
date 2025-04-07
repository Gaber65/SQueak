part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {}

class SearchError extends SearchState {}

class FollowLoading extends SearchState {}

class FollowSuccess extends SearchState {
  final isHavePet;

  FollowSuccess(this.isHavePet);
}

class FollowError extends SearchState {
  final ResponseModel error;

  FollowError(this.error);
}

final class GetSupplierLoading extends SearchState {}
final class GetSupplierSuccess extends SearchState {}
final class GetSupplierError extends SearchState {}