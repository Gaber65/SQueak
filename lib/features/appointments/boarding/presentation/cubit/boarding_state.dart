// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import '../../domain/entities/boarding_entry_entity.dart';
import '../../domain/entities/boarding_type_entity.dart';

abstract class BoardingState extends Equatable {
  const BoardingState();

  @override
  List<Object?> get props => [];
}

class BoardingInitial extends BoardingState {}

class BoardingLoading extends BoardingState {}

// Boarding Types States
class GetBoardingTypesLoading extends BoardingState {}

class GetBoardingTypesSuccess extends BoardingState {
  final List<BoardingTypeEntity> boardingTypes;

  const GetBoardingTypesSuccess(this.boardingTypes);

  @override
  List<Object?> get props => [boardingTypes];
}

class GetBoardingTypesError extends BoardingState {
  final String message;

  const GetBoardingTypesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Create Boarding States
class CreateBoardingLoading extends BoardingState {}

class CreateBoardingSuccess extends BoardingState {}

class CreateBoardingError extends BoardingState {
  final String message;

  const CreateBoardingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Edit Boarding States
class EditBoardingLoading extends BoardingState {}

class EditBoardingSuccess extends BoardingState {}

class EditBoardingError extends BoardingState {
  final String message;

  const EditBoardingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Boarding Entries States
class GetBoardingEntriesLoading extends BoardingState {}

class GetBoardingEntriesSuccess extends BoardingState {
  final List<BoardingEntryEntity> entries;

  const GetBoardingEntriesSuccess(this.entries);

  @override
  List<Object?> get props => [entries];
}

class GetBoardingEntriesError extends BoardingState {
  final String message;

  const GetBoardingEntriesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Rate Boarding States
class RateBoardingLoading extends BoardingState {}

class RateBoardingSuccess extends BoardingState {}

class RateBoardingError extends BoardingState {
  final String message;

  const RateBoardingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Filter States
class BoardingFiltered extends BoardingState {
  final List<BoardingEntryEntity> filteredEntries;

  const BoardingFiltered(this.filteredEntries);

  @override
  List<Object?> get props => [filteredEntries];
}

class BoardingFilteredClear extends BoardingState {
  final List<BoardingEntryEntity> entries;

  const BoardingFilteredClear(this.entries);

  @override
  List<Object?> get props => [entries];
}

class FilterState extends BoardingState {}