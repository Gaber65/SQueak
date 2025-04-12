import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:squeak/core/helper/cache/cache_helper.dart';
import 'package:squeak/core/helper/image_helper/helper_model/response_model.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';

import '../../../core/helper/remotely/dio.dart';
import '../../../generated/l10n.dart';
import '../models/pet_model.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {

  // init of the cubit get the cached pets and breeds
  PetCubit() : super(PetInitial()) {
    _loadCachedPets();
    _loadCachedBreeds();
  }

  static PetCubit get(BuildContext context) => BlocProvider.of(context);

  // List of pets and breeds
  List<PetsData> pets = [];
  List<BreadData> allBreeds = [];
  List<BreadData> breedData = [];
  List<BreadData> species = [];

  // Controllers for the form fields
  final formKey = GlobalKey<FormState>();
  final breedIdController = TextEditingController();
  final searchController = TextEditingController();
  final birthdateController = TextEditingController(text: DateTime.now().toString().substring(0, 10));
  final petNameController = TextEditingController();
  final imageNameController = TextEditingController();

  // Variables for the pet creation and editing
  int gender = 1;
  bool isLoading = false;
  bool spayed = false;
  File? pitsImage;

  String dropdownValueBreed = '';
  String dropdownValueSpecies = '';
  String dropdownValueSpeciesId = '';
  String petId = '';
  String specieId = '';

  final picker = ImagePicker();

  // Cached pets and breeds
  void _loadCachedPets() {
    final cached = CacheHelper.getData('usersPets');
    if (cached != null) {
      pets = List<PetsData>.from(json.decode(cached).map((x) => PetsData.fromJson(x)))
          .where((e) => e.petId != CacheHelper.getData('clintId'))
          .toList();
    }
  }
  void _loadCachedBreeds() {
    final cached = CacheHelper.getData('allBreeds');
    if (cached != null) {
      allBreeds = List<BreadData>.from(json.decode(cached).map((x) => BreadData.fromJson(x)));
    }
  }

  // API Call to get the owner's pets
  Future<void> getOwnerPet() async {
    emit(SqueakGetOwnerPetlaoding());
    try {
      final response = await DioFinalHelper.getData(method: getOwnerPetEndPoint, language: true);
      pets = (response.data['data']['petsDto'] as List).map((e) => PetsData.fromJson(e)).toList();
      CacheHelper.saveData('usersPets', json.encode(response.data['data']['petsDto']));
      emit(SqueakGetOwnerPetSuccess());
    } catch (e) {
      _handleError(e);
      emit(SqueakGetOwnerPetError());
    }
  }

  // API Call to get all breeds and species
  Future<void> getAllBreed() async {
    emit(GetAllBreedsLoadingState());
    try {
      final response = await DioFinalHelper.getData(method: allBreed, language: false);
      breedData = (response.data['data']['breedDto'] as List).map((x) => BreadData.fromJson(x)).toList();
      // print("get all breeds");
      // print('all breeds: ${response.data['data']['breedDto']}');
      CacheHelper.saveData('allBreeds', json.encode(response.data['data']['breedDto']));
      emit(GetAllBreedsSuccessState());
    } catch (e) {
      _handleError(e);
      emit(GetAllBreedsErrorState());
    }
  }

  Future<void> getAllBreeds(String id) async {
    emit(GetAllBreedsLoadingState());
    try {
      final response = await DioFinalHelper.getData(method: allBreedBySpeciesId + id, language: false);
      breedData = (response.data['data']['breedDto'] as List).map((x) => BreadData.fromJson(x)).toList();
      // print("get all breeds ${breedData}");
      emit(GetAllBreedsSuccessState());
    } catch (e) {
      _handleError(e);
      emit(GetAllBreedsErrorState());
    }
  }

  Future<void> getAllSpecies() async {
    emit(GetAllSpeciesLoadingState());
    try {
      final response = await DioFinalHelper.getData(method: allSpeciesEndPoint, language: false);
      species = (response.data['data']['speciesDtos'] as List).map((x) => BreadData.fromJson(x)).toList();
      // print("get all species ${species}");
      emit(GetAllSpeciesSuccessState());
    } catch (e) {
      _handleError(e);
      emit(GetAllSpeciesErrorState());
    }
  }

  void init(String species, String speciesId) {
    dropdownValueSpecies = species;
    dropdownValueSpeciesId = speciesId;
    emit(PetCreateSuccessState());
  }

  void initEdit(PetsData model) {
    petNameController.text = model.petName;
    breedIdController.text = model.breedId;
    birthdateController.text = model.birthdate.isEmpty ? '' : model.birthdate.substring(0, 10);
    imageNameController.text = model.imageName.contains('freepik') ? '' : model.imageName;
    gender = model.gender;
    petId = model.petId;
    specieId = model.specieId;
    spayed = model.isSpayed;
    dropdownValueBreed = model.breedId;
    searchController.text = model.breed?.enType ?? S.current.breed;
    emit(PetCreateSuccessState());
  }

  Map<String, dynamic> _preparePetData({bool isEdit = false}) {
    final data = {
      'petName': petNameController.text,
      'gender': gender,
      'imageName': imageNameController.text == 'PetAvatar.png' ? '' : imageNameController.text,
      'birthdate': birthdateController.text,
      'specieId': dropdownValueSpeciesId,
      'ownerId': CacheHelper.getData('clintId'),
      'isSpayed': spayed
    };

    if (breedIdController.text.isNotEmpty) {
      data['breedId'] = breedIdController.text;
    } else if (isEdit) {
      data['breedId'] = null;
    }

    return data;
  }

  // API Call to create
  void createPet() async {
    isLoading = true;
    emit(PetCreateLoadingState());
    try {
      final response = await DioFinalHelper.postData(
        method: addPetEndPint,
        data: _preparePetData(),
      );

      pets.add(PetsData.fromJson(response.data['data']));
      _cacheUpdatedPets();
      isLoading = false;
      emit(PetCreateSuccessState());
    } catch (e) {
      isLoading = false;
      _handleError(e, emitError: (msg) => PetCreateErrorState(msg));
    }
  }

  // API Call to edit
  void editPet() async {
    isLoading = true;
    emit(PetCreateLoadingState());
    try {
      final response = await DioFinalHelper.patchData(
        method: updatePetEndPint + petId,
        data: _preparePetData(isEdit: true),
      );

      pets.add(PetsData.fromJson(response.data['data']));
      _cacheUpdatedPets();
      isLoading = false;
      emit(PetCreateSuccessState());
    } catch (e) {
      isLoading = false;
      _handleError(e, emitError: (msg) => PetCreateErrorState(msg));
    }
  }


  void _cacheUpdatedPets() {
    final jsonPets = jsonEncode(pets.map((pet) => pet.toMap()).toList());
    CacheHelper.saveData('usersPets', jsonPets);
  }

  Future<void> deletePet(String id) async {
    emit(DeletePetLoadingState());
    try {
      await DioFinalHelper.deleteData(method: deletePetEndPint + id);
      getOwnerPet();
      emit(DeletePetSuccessState());
    } catch (e) {
      _handleError(e);
      emit(DeletePetErrorState());
    }

  }

  // functions to change the state of the form { gender , birthdate , image name , breed , species }
  void changeGender(int newGender) {
    gender = newGender;
    emit(ChangeGenderState());
  }

  void changeBirthdate(String date) {
    birthdateController.text = date;
    emit(ChangeBirthdateState());
  }

  void changeImageName(String name) {
    imageNameController.text = name;
    emit(ChangeImageNameState());
  }

  void changeBreed(String name, String id) {
    breedIdController.text = id;
    dropdownValueBreed = name;
    emit(ChangeBreedState());
  }

  void changeSpecies(String name, String id) {
    dropdownValueSpecies = name;
    dropdownValueSpeciesId = id;
    emit(ChangeSpeciesState());
  }

  void changeSpayed() {
    spayed = !spayed;
    emit(ChangeBreedState());
  }

  // function to pick image from gallery
  Future<void> getPitsImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pitsImage = File(pickedFile.path);
      emit(PitsImagePickedSuccessState());
    } else {
      emit(PitsImagePickedErrorState());
    }
  }


  void _handleError(dynamic error, {Function(ResponseModel)? emitError}) {
    if (error is DioException && error.response != null) {
      final responseModel = ResponseModel.fromJson(error.response!.data);
      if (emitError != null) {
        emitError(responseModel);
      } else {
        print(responseModel.message);
      }
    } else {
      print('Unexpected error: $error');
    }
  }

  @override
  Future<void> close() {
    CacheHelper.removeData('NotificationId');
    CacheHelper.removeData('NotificationType');
    return super.close();
  }
}




