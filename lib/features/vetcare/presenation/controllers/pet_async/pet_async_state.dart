part of 'pet_async_cubit.dart';

abstract class PetAsyncState {}

class PetAsyncInitial extends PetAsyncState {}

// Get clinic states
class LoadingGetClinicState extends PetAsyncState {}
class SuccessGetClinicState extends PetAsyncState {}
class ErrorGetClinicState extends PetAsyncState {}

// Add in squeak states
class LoadingAddInSqueakStatuesState extends PetAsyncState {}
class SuccessAddInSqueakStatuesState extends PetAsyncState {
  final String petId;
  SuccessAddInSqueakStatuesState(this.petId);
}
class ErrorAddInSqueakStatuesState extends PetAsyncState {
  final dynamic error;
  ErrorAddInSqueakStatuesState(this.error);
}