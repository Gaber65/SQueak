part of 'mating_feeds_cubit.dart';

@immutable
sealed class MatingFeedsState {}

final class MatingFeedsInitial extends MatingFeedsState {}
final class MatingFeedsLoading extends MatingFeedsState {}
final class MatingFeedsError extends MatingFeedsState {
  final String message;
  MatingFeedsError(this.message);
}

final class MatingFeedsLoaded extends MatingFeedsState {
  final List<PetEntities> pets;
  MatingFeedsLoaded(this.pets);
}



final class MatingRequestSentSuccess extends MatingFeedsState {}


final class MatingStatusUpdated extends MatingFeedsState {}
