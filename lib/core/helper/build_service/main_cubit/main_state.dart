part of 'main_cubit.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

class AppChangeModeState extends MainState {}

class AppChangeModeFromSharedState extends MainState {}

class SaveTokenLoading extends MainState {}

class SaveTokenSuccess extends MainState {}

class SaveTokenError extends MainState {}
class DeleteTokenSuccess extends MainState {}
class DeleteTokenLoading extends MainState {}

class ImageHelperLoading extends MainState {}

class ImageHelperSuccess extends MainState {
  final HelperModel helperModel;

  ImageHelperSuccess(this.helperModel);
}

class ImageHelperError extends MainState {}

class GetUserRefreshTokenLoading extends MainState {}

class GetUserRefreshTokenSuccess extends MainState {}

class GetUserRefreshTokenError extends MainState {
  final String error;

  GetUserRefreshTokenError(this.error);
}

class GetRefreshTokenSuccess extends MainState {}

class GetRefreshTokenLoading extends MainState {}

class GetRefreshTokenError extends MainState {
  final String error;

  GetRefreshTokenError(this.error);
}
