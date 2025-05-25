part of 'boarding_cubit.dart';

@immutable
sealed class BoardingState {}

final class BoardingInitial extends BoardingState {}


final class GetBoardingTypeState extends BoardingState {}
final class GetBoardingTypeSuccess extends BoardingState {}
final class GetBoardingTypeError extends BoardingState {}


final class CreateBoardingState extends BoardingState {}
final class CreateBoardingSuccess extends BoardingState {}
final class CreateBoardingError extends BoardingState {
  final ErrorMessageModel errorMessageModel;

  CreateBoardingError(this.errorMessageModel);
}
final class GetBoardingEntryState extends BoardingState {}
final class GetBoardingEntrySuccess extends BoardingState {}
final class GetBoardingEntryError extends BoardingState {}

final class RateBoardingLoading extends BoardingState {}
final class RateBoardingSuccess extends BoardingState {}
final class RateBoardingError extends BoardingState {}

final class BoardingFiltered extends BoardingState {
  final List<BoardingEntry> boardingEntry;

  BoardingFiltered(this.boardingEntry);
}
final class BoardingFilteredClear extends BoardingState {
  final List<BoardingEntry> boardingEntry;

  BoardingFilteredClear(this.boardingEntry);
}


