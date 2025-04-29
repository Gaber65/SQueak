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

