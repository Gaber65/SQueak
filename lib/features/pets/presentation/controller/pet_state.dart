part of 'pet_cubit.dart';

@immutable
sealed class PetState {
  const PetState();
}

final class PetInitial extends PetState {}

// Owner Pets States
class GetOwnerPetsLoadingState extends PetState {
  const GetOwnerPetsLoadingState();
}

class GetOwnerPetsSuccessState extends PetState {
  const GetOwnerPetsSuccessState();
}

class GetOwnerPetsErrorState extends PetState {
  final String message;

  const GetOwnerPetsErrorState(this.message);
}

// Breeds States
class GetAllBreedsLoadingState extends PetState {
  const GetAllBreedsLoadingState();
}

class GetAllBreedsSuccessState extends PetState {
  const GetAllBreedsSuccessState();
}

class GetAllBreedsErrorState extends PetState {
  final String message;

  const GetAllBreedsErrorState(this.message);
}

// Species States
class GetAllSpeciesLoadingState extends PetState {
  const GetAllSpeciesLoadingState();
}

class GetAllSpeciesSuccessState extends PetState {
  const GetAllSpeciesSuccessState();
}

class GetAllSpeciesErrorState extends PetState {
  final String message;

  const GetAllSpeciesErrorState(this.message);
}

// Pet CRUD States
class PetCreateLoadingState extends PetState {
  const PetCreateLoadingState();
}

class PetCreateSuccessState extends PetState {
  const PetCreateSuccessState();
}

class PetCreateErrorState extends PetState {
  final String message;

  const PetCreateErrorState(this.message);
}

class DeletePetLoadingState extends PetState {
  const DeletePetLoadingState();
}

class DeletePetSuccessState extends PetState {
  const DeletePetSuccessState();
}

class DeletePetErrorState extends PetState {
  final String message;

  const DeletePetErrorState(this.message);
}

// Form States - Optimized with single state class
class PetFormState extends PetState {
  final int gender;
  final String birthdate;
  final String imageName;
  final String breedId;
  final String breedName;
  final String speciesName;
  final String speciesId;
  final bool spayed;
  final String passportImageName;

  const PetFormState({
    this.gender = 1,
    this.birthdate = '',
    this.imageName = '',
    this.breedId = '',
    this.breedName = '',
    this.speciesName = '',
    this.speciesId = '',
    this.spayed = false,
    this.passportImageName = '',
  });

  PetFormState copyWith({
    int? gender,
    String? birthdate,
    String? imageName,
    String? breedId,
    String? breedName,
    String? speciesName,
    String? speciesId,
    bool? spayed,
    String? passportImageName,
  }) {
    return PetFormState(
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      imageName: imageName ?? this.imageName,
      breedId: breedId ?? this.breedId,
      breedName: breedName ?? this.breedName,
      speciesName: speciesName ?? this.speciesName,
      speciesId: speciesId ?? this.speciesId,
      spayed: spayed ?? this.spayed,
      passportImageName: passportImageName ?? this.passportImageName,
    );
  }
}

class PetImagePickedSuccessState extends PetState {}

class PetImagePickedErrorState extends PetState {}

// Deprecated states - kept for backward compatibility, can be removed later
@Deprecated('Use PetFormState instead')
final class PetFormUpdatedState extends PetState {}

@Deprecated('Use proper loading/success states')
final class SqueakGetOwnerPetlaoding extends PetState {}

@Deprecated('Use proper loading/success states')
final class SqueakGetOwnerPetSuccess extends PetState {}

@Deprecated('Use proper loading/success states')
final class SqueakGetOwnerPetError extends PetState {}

@Deprecated('Use proper error states')
final class AddPetError extends PetState {}

@Deprecated('Use PetFormState with copyWith')
final class ChangeGenderState extends PetState {}

@Deprecated('Use PetFormState with copyWith')
final class ChangeBirthdateState extends PetState {}

@Deprecated('Use PetFormState with copyWith')
final class ChangeImageNameState extends PetState {}

@Deprecated('Use PetFormState with copyWith')
final class ChangeBreedState extends PetState {}

@Deprecated('Use PetFormState with copyWith')
final class ChangeSpeciesState extends PetState {}

@Deprecated('Use PetImagePickedSuccessState')
final class PitsImagePickedSuccessState extends PetState {}

@Deprecated('Use PetImagePickedErrorState')
final class PitsImagePickedErrorState extends PetState {}

final class MergePetsLoadingState extends PetState {
  const MergePetsLoadingState();
}

final class MergePetsSuccessState extends PetState {
  const MergePetsSuccessState();
}

final class MergePetsErrorState extends PetState {
  final String message;

  const MergePetsErrorState(this.message);
}
