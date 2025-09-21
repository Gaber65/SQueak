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

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final GetOwnerPetsUseCase getOwnerPetsUseCase;
  final GetAllBreedsUseCase getAllBreedsUseCase;
  final GetBreedsBySpeciesUseCase getBreedsBySpeciesUseCase;
  final GetAllSpeciesUseCase getAllSpeciesUseCase;
  final CreatePetUseCase createPetUseCase;
  final UpdatePetUseCase updatePetUseCase;
  final DeletePetUseCase deletePetUseCase;

  PetCubit({
    required this.getOwnerPetsUseCase,
    required this.getAllBreedsUseCase,
    required this.getBreedsBySpeciesUseCase,
    required this.getAllSpeciesUseCase,
    required this.createPetUseCase,
    required this.updatePetUseCase,
    required this.deletePetUseCase,
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
    emit(GetOwnerPetsLoadingState());

    final result = await getOwnerPetsUseCase(NoParameters());

    result.fold(
      (error) => emit(GetOwnerPetsErrorState(extractFirstError(error))),
      (petsList) {
        pets = petsList;
        CacheHelper.saveData('havePets', pets.length);
        emit(GetOwnerPetsSuccessState());
      },
    );
  }

  // Get all breeds
  Future<void> getAllBreeds() async {
    emit(GetAllBreedsLoadingState());

    final result = await getAllBreedsUseCase(NoParameters());

    result.fold(
      (error) => emit(GetAllBreedsErrorState(extractFirstError(error))),
      (breedsList) {
        allBreeds = breedsList;
        emit(GetAllBreedsSuccessState());
      },
    );
  }

  // Get breeds by species ID
  Future<void> getBreedsBySpecies(String speciesId) async {
    emit(GetAllBreedsLoadingState());

    final result = await getBreedsBySpeciesUseCase(speciesId);

    result.fold(
      (error) => emit(GetAllBreedsErrorState(extractFirstError(error))),
      (breedsList) {
        breedData = breedsList;
        emit(GetAllBreedsSuccessState());
      },
    );
  }

  // Get all species
  Future<void> getAllSpecies() async {
    emit(GetAllSpeciesLoadingState());

    final result = await getAllSpeciesUseCase(NoParameters());

    result.fold(
      (error) => emit(GetAllSpeciesErrorState(extractFirstError(error))),
      (speciesList) {
        species = speciesList;
        emit(GetAllSpeciesSuccessState());
      },
    );
  }

  // Initialize form for creating a new pet
  void init(String speciesName, String speciesId) {
    dropdownValueSpecies = speciesName;
    dropdownValueSpeciesId = speciesId;
    emit(PetFormUpdatedState());
  }

  // Initialize form for editing an existing pet
  void initEdit(PetEntities pet) {
    print(pet.toJson());
    print(pet.breed);
    searchController.text =
        (isArabic()
            ? pet.breed?.arBreed
            : pet.breed?.enBreed ?? S.current.breed) ??
        '';
    petNameController.text = pet.petName;
    breedIdController.text = pet.breedId;
    birthdateController.text =
        pet.birthdate.isEmpty ? '' : pet.birthdate.substring(0, 10);
    imageNameController.text =
        pet.imageName.toString().contains('freepik')
            ? ''
            : pet.imageName.toString();
    // Add passport fields initialization
    passportNumberController.text = pet.passportNumber ?? '';
    passportImageNameController.text = pet.passportImage ?? '';
    microchipNumberController.text = pet.microShipNumber ?? '';

    gender = pet.gender;
    petId = pet.petId.toString();
    specieId = pet.specieId.toString();
    spayed = pet.isSpayed;
    dropdownValueBreed = pet.breedId;
    emit(PetFormUpdatedState());
  }

  // Create a new pet
  Future<void> createPet() async {
    isLoading = true;
    emit(PetCreateLoadingState());

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
    print(pet.toJson());
    final result = await createPetUseCase(PetParams(pet: pet));

    isLoading = false;
    result.fold(
      (error) {
        print(error.error.toJson());
        emit(PetCreateErrorState(extractFirstError(error)));
      },
      (createdPet) {
        pets.add(createdPet);
        emit(PetCreateSuccessState());
      },
    );
  }

  // Update an existing pet
  Future<void> updatePet() async {
    isLoading = true;
    emit(PetCreateLoadingState());
    print(microchipNumberController.text);
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
        emit(PetCreateSuccessState());
      },
    );
  }

  // Delete a pet
  Future<void> deletePet(String id) async {
    emit(DeletePetLoadingState());

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

        emit(DeletePetSuccessState());
        print(CacheHelper.getData('havePets'));
      },
    );
  }

  // Form field update methods
  void changeGender(int newGender) {
    gender = newGender;
    emit(PetFormUpdatedState());
  }

  void changeBirthdate(String date) {
    birthdateController.text = date;
    emit(PetFormUpdatedState());
  }

  void changeImageName(String name) {
    imageNameController.text = name;
    emit(PetFormUpdatedState());
  }

  void changeBreed(String name, String id) {
    breedIdController.text = id;
    dropdownValueBreed = name;
    emit(PetFormUpdatedState());
  }

  void changeSpecies(String name, String id) {
    dropdownValueSpecies = name;
    dropdownValueSpeciesId = id;
    emit(PetFormUpdatedState());
  }

  void changeSpayed() {
    spayed = !spayed;
    emit(PetFormUpdatedState());
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
    emit(PetFormUpdatedState());
  }

  // Change passport image name
  void changePassportImageName(String name) {
    passportImageNameController.text = name;
    emit(PetFormUpdatedState());
  }

  @override
  Future<void> close() {
    // Clean up controllers
    breedIdController.dispose();
    searchController.dispose();
    birthdateController.dispose();
    petNameController.dispose();
    imageNameController.dispose();
    return super.close();
  }
}
