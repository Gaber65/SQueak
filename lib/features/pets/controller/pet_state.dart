part of 'pet_cubit.dart';

@immutable
sealed class PetState {}

final class PetInitial extends PetState {}

final class PetCreateLoadingState extends PetState {}

final class SqueakGetOwnerPetlaoding extends PetState {}

final class SqueakGetOwnerPetSuccess extends PetState {}

final class SqueakGetOwnerPetError extends PetState {}

final class AddPetError extends PetState {}

final class PetCreateSuccessState extends PetState {}

final class PetCreateErrorState extends PetState {
  final ResponseModel error;

  PetCreateErrorState(this.error);
}

final class ChangeGenderState extends PetState {}

final class ChangeBirthdateState extends PetState {}

final class ChangeImageNameState extends PetState {}

final class ChangeBreedState extends PetState {}

final class ChangeSpeciesState extends PetState {}

final class PitsImagePickedSuccessState extends PetState {}

final class PitsImagePickedErrorState extends PetState {}

final class GetAllBreedsLoadingState extends PetState {}

final class GetAllBreedsSuccessState extends PetState {}

final class GetAllBreedsErrorState extends PetState {}

final class GetAllSpeciesLoadingState extends PetState {}

final class GetAllSpeciesSuccessState extends PetState {}

final class GetAllSpeciesErrorState extends PetState {}

final class DeletePetLoadingState extends PetState {}

final class DeletePetSuccessState extends PetState {}

final class DeletePetErrorState extends PetState {}
