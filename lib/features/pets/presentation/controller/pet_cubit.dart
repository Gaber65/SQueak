import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/core/base_usecase/base_usecase.dart';
import 'package:squeak/core/network/dio.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import '../../../../features/pets/domain/entities/pet_entity.dart';
import '../../../../features/pets/domain/use_case/get_owner_pets_usecase.dart';
import '../../../../features/pets/domain/use_case/get_all_breeds_usecase.dart';
import '../../../../features/pets/domain/use_case/get_breeds_by_species_usecase.dart';
import '../../../../features/pets/domain/use_case/get_all_species_usecase.dart';
import '../../../../features/pets/domain/use_case/create_pet_usecase.dart';
import '../../../../features/pets/domain/use_case/update_pet_usecase.dart';
import '../../../../features/pets/domain/use_case/delete_pet_usecase.dart';
import '../../../../generated/l10n.dart';
import '../../domain/use_case/merge_pets_usecase.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final GetOwnerPetsUseCase getOwnerPetsUseCase;
  final GetAllBreedsUseCase getAllBreedsUseCase;
  final GetBreedsBySpeciesUseCase getBreedsBySpeciesUseCase;
  final GetAllSpeciesUseCase getAllSpeciesUseCase;
  final CreatePetUseCase createPetUseCase;
  final UpdatePetUseCase updatePetUseCase;
  final DeletePetUseCase deletePetUseCase;
  final MergePetsUsecase mergePetsUseCase;
  // final birthdateController = TextEditingController();
  // final CreatePetLoginScreenUseCase createPetLoginScreenUseCase;

  PetCubit(
  // this.createPetLoginScreenUseCase,
  {
    required this.getOwnerPetsUseCase,
    required this.getAllBreedsUseCase,
    required this.getBreedsBySpeciesUseCase,
    required this.getAllSpeciesUseCase,
    required this.createPetUseCase,
    required this.updatePetUseCase,
    required this.deletePetUseCase,
    required this.mergePetsUseCase,
  }) : super(PetInitial());

  static PetCubit get(context) => BlocProvider.of(context);

  // Lists to store data
  List<PetEntities> pets = [];
  List<BreedEntity> allBreeds = [];
  List<BreedEntity> breedData = [];
  List<SpeciesEntity> species = [];

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final breedIdController = TextEditingController();
  final searchController = TextEditingController();
  final birthdateController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  );
  final petNameController = TextEditingController();
  final imageNameController = TextEditingController();
  final passportNumberController = TextEditingController();
  final microchipNumberController = TextEditingController();
  final passportImageNameController = TextEditingController();

  // Form state
  int gender = 1;
  bool isLoading = false;
  bool spayed = false;
  File? petImage;
  File? passportImage;

  String dropdownValueBreed = '';
  String dropdownValueSpecies = '';
  String dropdownValueSpeciesId = '';
  String petId = '';
  String specieId = '';

  final picker = ImagePicker();

  // Load cached data on initialization

  // Get owner's pets
  Future<void> getOwnerPets() async {
    emit(const GetOwnerPetsLoadingState());

    final result = await getOwnerPetsUseCase(NoParameters());

    result.fold(
      (error) => emit(GetOwnerPetsErrorState(extractFirstError(error))),
      (petsList) {
        pets = petsList;
        CacheHelper.saveData('havePets', pets.length);
        emit(const GetOwnerPetsSuccessState());
      },
    );
  }

  // Get all breeds
  Future<void> getAllBreeds() async {
    emit(const GetAllBreedsLoadingState());

    final result = await getAllBreedsUseCase(NoParameters());

    result.fold(
      (error) => emit(GetAllBreedsErrorState(extractFirstError(error))),
      (breedsList) {
        allBreeds = breedsList;
        emit(const GetAllBreedsSuccessState());
      },
    );
  }

  // Get breeds by species ID
  Future<void> getBreedsBySpecies(String speciesId) async {
    emit(const GetAllBreedsLoadingState());

    final result = await getBreedsBySpeciesUseCase(speciesId);

    result.fold(
      (error) => emit(GetAllBreedsErrorState(extractFirstError(error))),
      (breedsList) {
        breedData = breedsList;
        emit(const GetAllBreedsSuccessState());
      },
    );
  }

  // Get all species
  Future<void> getAllSpecies() async {
    emit(const GetAllSpeciesLoadingState());

    final result = await getAllSpeciesUseCase(NoParameters());

    result.fold(
      (error) => emit(GetAllSpeciesErrorState(extractFirstError(error))),
      (speciesList) {
        species = speciesList;
        emit(const GetAllSpeciesSuccessState());
      },
    );
  }

  // Initialize form for creating a new pet
  void init(String speciesName, String speciesId) {
    dropdownValueSpecies = speciesName;
    dropdownValueSpeciesId = speciesId;
    emit(PetFormState(
      gender: gender,
      birthdate: birthdateController.text,
      imageName: imageNameController.text,
      breedId: breedIdController.text,
      breedName: dropdownValueBreed,
      speciesName: speciesName,
      speciesId: speciesId,
      spayed: spayed,
      passportImageName: passportImageNameController.text,
    ));
  }

  // Initialize form for editing an existing pet
  void initEdit(PetEntities pet) {
    searchController.text =
        (isArabic()
            ? pet.breed?.arBreed
            : pet.breed?.enBreed ?? S.current.breed) ??
        '';
    petNameController.text = pet.petName ?? '';
    breedIdController.text = pet.breedId ?? '';
    birthdateController.text =
        (pet.birthdate?.isNotEmpty ?? false)
            ? pet.birthdate!.substring(0, 10)
            : '';

    imageNameController.text =
        pet.imageName.toString().contains('freepik')
            ? ''
            : pet.imageName.toString();
    // Add passport fields initialization
    passportNumberController.text = pet.passportNumber ?? '';
    passportImageNameController.text = pet.passportImage ?? '';
    microchipNumberController.text = pet.microShipNumber ?? '';

    gender = pet.gender ?? 0;
    petId = pet.petId.toString();
    specieId = pet.specieId.toString();
    spayed = pet.isSpayed ?? false;
    dropdownValueBreed = pet.breedId ?? '';
    emit(PetFormState(
      gender: gender,
      birthdate: birthdateController.text,
      imageName: imageNameController.text,
      breedId: breedIdController.text,
      breedName: dropdownValueBreed,
      speciesName: dropdownValueSpecies,
      speciesId: dropdownValueSpeciesId,
      spayed: spayed,
      passportImageName: passportImageNameController.text,
    ));
  }

  // Create a new pet
  Future<void> createPet() async {
    isLoading = true;
    emit(const PetCreateLoadingState());

    final pet = PetEntities(
      petId: '',
      petName: petNameController.text,
      breedId: breedIdController.text,
      isSpayed: spayed,
      gender: gender,
      specieId: dropdownValueSpeciesId,
      imageName:
          imageNameController.text == 'PetAvatar.png'
              ? ''
              : imageNameController.text,
      birthdate: birthdateController.text,
      passportImage:
          passportImageNameController.text.isEmpty
              ? ''
              : passportImageNameController.text,
      passportNumber:
          passportNumberController.text.isEmpty
              ? ''
              : passportNumberController.text,
      microShipNumber:
          microchipNumberController.text.isEmpty
              ? ''
              : microchipNumberController.text,
    );

    final result = await createPetUseCase(PetParams(pet: pet));

    isLoading = false;
    result.fold(
      (error) {
        emit(PetCreateErrorState(extractFirstError(error)));
      },
      (createdPet) {
        pets.add(createdPet);
        emit(const PetCreateSuccessState());
      },
    );
  }

  // Create a new pet
  Future<void> createPetGetStarting({required PetEntities pet}) async {
    isLoading = true;
    emit(const PetCreateLoadingState());

    // print(pet.toJson());
    final result = await createPetUseCase(PetParams(pet: pet));

    isLoading = false;
    result.fold(
      (error) {
        // print(error.error.toJson());
        emit(PetCreateErrorState(extractFirstError(error)));
      },
      (createdPet) {
        pets.add(createdPet);
        // Update the petId and specieId with the newly created pet's values
        petId = createdPet.petId ?? '';
        specieId = createdPet.specieId ?? '';
        emit(const PetCreateSuccessState());
      },
    );
  }

  // Update an existing pet
  Future<void> updatePet() async {
    isLoading = true;
    emit(const PetCreateLoadingState());
    final pet = PetEntities(
      petId: petId,
      petName: petNameController.text,
      breedId: breedIdController.text,
      isSpayed: spayed,
      gender: gender,
      specieId: specieId,
      imageName:
          imageNameController.text == 'PetAvatar.png'
              ? ''
              : imageNameController.text,
      birthdate: birthdateController.text,
      passportImage:
          passportImageNameController.text.isEmpty
              ? ''
              : passportImageNameController.text,
      passportNumber:
          passportNumberController.text.isEmpty
              ? ''
              : passportNumberController.text,
      microShipNumber:
          microchipNumberController.text.isEmpty
              ? ''
              : microchipNumberController.text,
    );

    final result = await updatePetUseCase(PetParams(pet: pet));

    isLoading = false;
    result.fold(
      (error) => emit(PetCreateErrorState(extractFirstError(error))),
      (updatedPet) {
        final index = pets.indexWhere((p) => p.petId.toString() == petId);
        if (index != -1) {
          pets[index] = updatedPet;
        }
        emit(const PetCreateSuccessState());
      },
    );
  }

  // Delete a pet
  Future<void> deletePet(String id) async {
    emit(const DeletePetLoadingState());

    final result = await deletePetUseCase(id);

    result.fold(
      (error) => emit(DeletePetErrorState(extractFirstError(error))),
      (_) async {
        // Remove pet from in-memory list
        pets.removeWhere((pet) => pet.petId.toString() == id);

        // Remove old cached data
        await CacheHelper.removeData('pets');

        // Save updated list in cache
        await CacheHelper.saveData(
          'havePets',
          jsonEncode(pets.map((e) => e.toJson()).toList()),
        );

        emit(const DeletePetSuccessState());
      },
    );
  }

  // Form field update methods - Optimized to use single state
  void changeGender(int newGender) {
    gender = newGender;
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(gender: newGender));
  }

  void changeBirthdate(String date) {
    birthdateController.text = date;
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(birthdate: date));
  }

  void changeImageName(String name) {
    imageNameController.text = name;
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(imageName: name));
  }

  void changeBreed(String name, String id) {
    breedIdController.text = id;
    dropdownValueBreed = name;
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(breedId: id, breedName: name));
  }

  void changeSpecies(String name, String id) {
    dropdownValueSpecies = name;
    dropdownValueSpeciesId = id;
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(speciesName: name, speciesId: id));
  }

  void changeSpayed() {
    spayed = !spayed;
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(spayed: spayed));
  }

  // Helper method to create form state from current values
  PetFormState _createFormState() {
    return PetFormState(
      gender: gender,
      birthdate: birthdateController.text,
      imageName: imageNameController.text,
      breedId: breedIdController.text,
      breedName: dropdownValueBreed,
      speciesName: dropdownValueSpecies,
      speciesId: dropdownValueSpeciesId,
      spayed: spayed,
      passportImageName: passportImageNameController.text,
    );
  }

  // Pick image from gallery
  Future<void> getPetImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      petImage = File(pickedFile.path);
      emit(PetImagePickedSuccessState());
    } else {
      emit(PetImagePickedErrorState());
    }
  }

  Future<void> getPassportImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      passportImage = File(pickedFile.path);
      emit(PetImagePickedSuccessState());
    } else {
      emit(PetImagePickedErrorState());
    }
  }

  void removePassportImage() {
    passportImage = null;
    passportImageNameController.clear();
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(passportImageName: ''));
  }

  // Change passport image name
  void changePassportImageName(String name) {
    passportImageNameController.text = name;
    final currentState = state is PetFormState ? state as PetFormState : _createFormState();
    emit(currentState.copyWith(passportImageName: name));
  }

  @override
  Future<void> close() {
    // Clean up controllers
    breedIdController.dispose();
    searchController.dispose();
    birthdateController.dispose();
    petNameController.dispose();
    imageNameController.dispose();
    // Dispose additional controllers that were missing
    passportNumberController.dispose();
    microchipNumberController.dispose();
    passportImageNameController.dispose();
    return super.close();
  }

  // merge pets
  Future<void> mergePets(List<String> ids) async {
    emit(const MergePetsLoadingState());
    final result = await mergePetsUseCase(ids);
    result.fold(
      (error) {
        emit(MergePetsErrorState(extractFirstError(error)));
      },
      (mergedPet) {
        pets.removeWhere((pet) => ids.contains(pet.petId));
        pets.add(mergedPet);
        emit(const MergePetsSuccessState());
      },
    );
  }
}
