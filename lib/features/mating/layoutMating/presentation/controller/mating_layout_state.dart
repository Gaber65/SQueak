part of 'mating_layout_cubit.dart';

@immutable
sealed class MatingLayoutState {}

final class MatingLayoutInitial extends MatingLayoutState {}
final class ChangeIndexState extends MatingLayoutState {}
