part of 'pet_cubit.dart';

@immutable
sealed class PetState {}

final class PetInitial extends PetState {}

// Owner Pets States
class GetOwnerPetsLoadingState extends PetState {}

class GetOwnerPetsSuccessState extends PetState {}

class GetOwnerPetsErrorState extends PetState {
  final String message;

  GetOwnerPetsErrorState(this.message);
}

// Breeds States
class GetAllBreedsLoadingState extends PetState {}

class GetAllBreedsSuccessState extends PetState {}

class GetAllBreedsErrorState extends PetState {
  final String message;

  GetAllBreedsErrorState(this.message);
}

// Species States
class GetAllSpeciesLoadingState extends PetState {}

class GetAllSpeciesSuccessState extends PetState {}

class GetAllSpeciesErrorState extends PetState {
  final String message;

  GetAllSpeciesErrorState(this.message);
}

// Pet CRUD States
class PetCreateLoadingState extends PetState {}

class PetCreateSuccessState extends PetState {}

class PetCreateErrorState extends PetState {
  final String message;

  PetCreateErrorState(this.message);
}

class DeletePetLoadingState extends PetState {}

class DeletePetSuccessState extends PetState {}

class DeletePetErrorState extends PetState {
  final String message;

  DeletePetErrorState(this.message);
}

// Form States
class PetFormUpdatedState extends PetState {}

class PetImagePickedSuccessState extends PetState {}

class PetImagePickedErrorState extends PetState {}

final class SqueakGetOwnerPetlaoding extends PetState {}

final class SqueakGetOwnerPetSuccess extends PetState {}

final class SqueakGetOwnerPetError extends PetState {}

final class AddPetError extends PetState {}

final class ChangeGenderState extends PetState {}

final class ChangeBirthdateState extends PetState {}

final class ChangeImageNameState extends PetState {}

final class ChangeBreedState extends PetState {}

final class ChangeSpeciesState extends PetState {}

final class PitsImagePickedSuccessState extends PetState {}

final class PitsImagePickedErrorState extends PetState {}
